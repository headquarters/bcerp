require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'json'

set :bind, '0.0.0.0'

enable :sessions

set :session_secret, "alsdkjf!#$alkd@#$sfj29734))98)"
set :sessions, :expire_after => 2592000

configure :development do
  DataMapper::Logger.new($stdout, :debug)
end

DataMapper.setup(:default, 'sqlite:bcerp.db')

require './models'

rebuild_tables = false

if rebuild_tables
  # auto_migrate clears all the data from the database
  DataMapper.auto_migrate! 
  require './schema'
else
  # auto_upgrade tries to reconcile existing database with schema changes
  DataMapper.auto_upgrade! 
end

DataMapper.finalize

SITE_TITLE = "Breast Health Awareness"

# Height and weight count as 1 question (BMI).
TOTAL_QUESTIONS = 17

# Use round() when displaying.
INCREMENT = 100.0/TOTAL_QUESTIONS

# Group ID is set manually in the schema.rb
HEIGHT_WEIGHT_GROUP_ID = 6
LAST_GROUP_ID = 17
BMI_GROUP_ID = 18
RACE_GROUP_ID = 2

# These IDs are set by the database engine, so they could theoretically change,
# but we're assuming nothing runs before the schema.rb script to insert other data
HEIGHT_QUESTION_ID = 6
WEIGHT_QUESTION_ID = 7
BMI_QUESTION_ID = 19
HIGHER_RISK_LEVEL_ID = 1
LOWER_RISK_LEVEL_ID = 2

before do
  # get the first session with this session_id or just create it and return that session row
  @session = Session.first_or_create(:session_id => session.id)
end

get '/' do
  @active = "home"
  erb :home  
end

get '/questionnaire/intro' do
  erb :intro
end

get '/questionnaire' do
  @active = "questionnaire"
  # "#{@session.current_question.inspect}"
  if !@session.current_question.nil?
    redirect "/questionnaire/#{@session.current_question}"
  else
    redirect "/questionnaire/1"
  end
end

get '/results/dismiss' do
  # While still developing...
  # @session.has_viewed_results = true
  # did_save = @session.save
  did_save = true
  
  if request.xhr?
    content_type :json
    { :status => did_save }.to_json
  else
    redirect "/results"
  end
end

get '/results/shared' do
  shared_session_id = params[:session_id]
  
  "You are viewing " + shared_session_id
end

["/results", "/questionnaire/results"].each do |path|
  get path do
    @active = "questionnaire"
    
    @results = {}    
    
    questions = Question.all(:order => :category_id.asc)
    
    @lower_risk_count = 0
    @higher_risk_count = 0
    
    questions.each do |question|
      # leave out race, height, and weight
      group_id = question.group_id
      if group_id == HEIGHT_WEIGHT_GROUP_ID || group_id == RACE_GROUP_ID
        next
      end
      
      category = question.category
      
      if @results[category.id].nil?
        # new category ID for the data structure, set it up to contain answers
        @results[category.id] = {}
  
        @results[category.id]["category_name"] = category.category_name
        @results[category.id]["category_id"] = category.category_identifier
        @results[category.id]["answers"] = []      
      end
      
      answer_hash = {}
      
      if group_id == BMI_GROUP_ID
        answer_hash["group_id"] = HEIGHT_WEIGHT_GROUP_ID
      else
        answer_hash["group_id"] = group_id
      end
      
      answer = Answer.first(:session_id => @session.id, :group_id => group_id)

      if answer.nil?
        answer_hash["risk"] = "unanswered"
      else
        answer_hash["risk"] = answer.question_option.risk_level.risk_level_identifier
        
        if answer.question_option.risk_level.id == HIGHER_RISK_LEVEL_ID
          @higher_risk_count += 1
        elsif answer.question_option.risk_level.id == LOWER_RISK_LEVEL_ID
          @lower_risk_count += 1
        end
      end
      
      answer_hash["question"] = Question.first(:group_id => group_id).question_name
      
      @results[category.id]["answers"].push(answer_hash)
        
    end
    
    #"#{@results.inspect}"
    erb :results
  end
end

get '/questionnaire/:group_id' do
  group_id = params[:group_id]
  
  @session.current_question = group_id
  @session.save
  
  @progress = @session.progress.round()
  
  @questions = Question.all(:group_id => group_id)
  
  @group_id = group_id.to_i
  
  # assumes all questions in a group share the same category
  @category_name = @questions.first.category.category_name
  @category_identifier = @questions.first.category.category_identifier
  
  if group_id != HEIGHT_WEIGHT_GROUP_ID.to_s
    @risk_messages = RiskMessage.all(:group_id => group_id)
  else
    # risk messages for height and weight must come from BMI
    @risk_messages = RiskMessage.all(:group_id => BMI_GROUP_ID)
  end
  
  @question_options = {}
  
  @answers = {}
  
  @questions.each do |q|
    @question_options[q.id] = QuestionOption.all(:question_id => q.id)
    # messes up after BMI questions because q.id would be 13, while group_id was one behind (12)
    @answers[q.id] = Answer.first(:session_id => @session.id, :question_id => q.id)
  end
  
  # keep the same nav item active the whole way through
  @active = "questionnaire"
  
  erb :question
end

post '/questionnaire/:group_id' do
  group_id = params[:group_id]
  
  next_group_id = group_id.to_i + 1;

  answers = params[:answers]
    
  # TODO: if the first_child is answered as "No Children", skip the breast feeding question, but
  # put the same high risk answer there???

  if !answers.nil?
    if group_id.to_i == HEIGHT_WEIGHT_GROUP_ID
      height_question_option_id = answers[HEIGHT_QUESTION_ID.to_s]
      weight_question_option_id = answers[WEIGHT_QUESTION_ID.to_s]
      
      height_question_option = QuestionOption.get(height_question_option_id)
      weight_question_option = QuestionOption.get(weight_question_option_id)
      
      height_in_inches = height_question_option.option_choice.option_choice_value
      weight_in_pounds = weight_question_option.option_choice.option_choice_value
  
      bmi = calculate_bmi(weight_in_pounds, height_in_inches)
      bmi_question_options = QuestionOption.all(:question_id => BMI_QUESTION_ID) 
      bmi_option_choice = bmi_question_options.option_choices.first(:conditions => ['option_choice_value > ?', bmi])
      
      #puts ">>>> #{bmi_question_options}, #{bmi_option_choice}"
      
      # save the BMI "question" answer, which isn't visible to the user
      # height and weight answers are saved independently below where the other answers are saved
      answer = Answer.first_or_new(:session_id => @session.id, :question_id => BMI_QUESTION_ID)
      answer.group_id = BMI_GROUP_ID
      answer.question_option = QuestionOption.first(:option_choice_id => bmi_option_choice.id, :question_id => BMI_QUESTION_ID)
      answer.save
      
      # save the BMI value to the session for easier retrieval later
      @session.bmi = bmi
      @session.save
    end
    
    
    answers.each do |question_id, question_option_id|
      answer = Answer.first_or_new(:session_id => @session.id, :question_id => question_id)
      answer.group_id = group_id
      answer.question_option = QuestionOption.get(question_option_id)
      answer.save
    end    
  end    
  
  progress = get_progress
  
  @session.progress = progress
  
  did_save = @session.save
  
  if request.xhr?
    content_type :json
    { :status => did_save, :progress => progress.round() }.to_json
  else
    if next_group_id <= LAST_GROUP_ID
      redirect "/questionnaire/#{next_group_id}"
    else
      redirect "/results"
    end
  end
end


get '/resources' do
  @active = "resources"
  erb :resources
end

get '/resources/:view' do
  @active = "resources"
  erb "#{params[:view]}".to_sym
end

get '/stories' do
  @active = "stories"
  erb :stories
end

get '/stories/:view' do
  @active = "stories"
  erb "stories/#{params[:view]}".to_sym
end

get '/reset' do
  # clear previous session, but leave the data in the database
  
  session.destroy
  redirect "/"
end

error do
  erb :'500'
end

not_found do
  erb :'404'
end

def get_progress
  # in answers table, count number of rows with this session_id
  count = Answer.count(:session_id => @session.id, :conditions => ['group_id != ?', HEIGHT_WEIGHT_GROUP_ID])
  
  if count > TOTAL_QUESTIONS
    count = TOTAL_QUESTIONS
  end
  
  return count * INCREMENT
end

def calculate_bmi(weight_in_pounds, height_in_inches)
  # coerce values to float to force float division, rather than integer division
  return ((weight_in_pounds.to_f/height_in_inches.to_f**2) * 703).round(2)
end

helpers do
  def prevent_widows(text)
    if text.kind_of? String
      trimmed_text = text.rstrip
      last_space_index = trimmed_text.rindex(" ")
      
      text[last_space_index] = "&nbsp;"
    end

    return text
  end
end