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

DataMapper.auto_upgrade! 

DataMapper.finalize

SITE_TITLE = "My Breast Cancer Risk"
TITLE = "My BC Risk"
@@page_title = ""

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
AGE_QUESTION_ID = 1
HEIGHT_QUESTION_ID = 6
WEIGHT_QUESTION_ID = 7
MAMMOGRAM_QUESTION_ID = 17
BMI_QUESTION_ID = 19
HIGHER_RISK_LEVEL_ID = 1
LOWER_RISK_LEVEL_ID = 2

before do
  # get the first session with this session_id or just create it and return that session row
  @session = Session.first_or_create(:session_id => session.id)
  
  # set default share URL; view can override it
  @@share_url = "http://mybcrisk.org"
end

get '/' do
  @@page_title = "Home | " + TITLE
  @active = "home"
  erb :home  
end

get '/questionnaire/intro' do
  @@page_title = "Questionnaire | " + TITLE
  erb :intro
end

get '/questionnaire' do
  @active = "questionnaire"
  if !@session.current_question.nil?
    redirect "/questionnaire/#{@session.current_question}"
  else
    redirect "/questionnaire/1"
  end
end

get '/results/dismiss' do
  @session.has_viewed_results = true
  did_save = @session.save
  
  if request.xhr?
    content_type :json
    { :status => did_save }.to_json
  else
    redirect "/results"
  end
end

get '/results/saved' do
  answers = Answer.all(:session_id => @session.id)
  
  query_string = "?"

  if answers.empty?
    query_string += "0"
  else
    answers.each_with_index do |answer, index|
      # <index>=group_id, question_option_id, question_id
      query_string += "a#{index}=#{answer.question_id},#{answer.question_option_id},#{answer.group_id}&"
    end
    
    # chop off the last ampersand
    query_string.chop!
  end
  
  redirect "/results#{query_string}"
end

["/results", "/questionnaire/results"].each do |path|
  get path do
    @@page_title = "Results | " + TITLE
    
    @active = "questionnaire"
    
    if !request.query_string.empty? && @session.progress == 0.0
      # parse query string for
      load_results(request.query_string)      
    end
    
    @results = {}    
    
    questions = Question.all(:order => :category_id.asc)
    
    @lower_risk_count = 0
    @higher_risk_count = 0
    
    questions.each do |question|
      group_id = question.group_id
      # leave out race, height, and weight
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
  
  @@page_title = "Question #{group_id} | " + TITLE
  
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
    @answers[q.id] = Answer.first(:session_id => @session.id, :question_id => q.id)
  end
  
  if group_id.to_i == MAMMOGRAM_QUESTION_ID
    age = Answer.first(:session_id => @session.id, :group_id => AGE_QUESTION_ID)
    if !age.nil? && age.question_option.option_choice.option_choice_value < 40
      # remove part of question regarding mammograms for users < 40
      @questions[0].question_name.gsub!(" and/or mammograms", "")
    end    
  end
  
  # keep the same nav item active the whole way through
  @active = "questionnaire"
  
  erb :question
end

post '/questionnaire/:group_id' do
  group_id = params[:group_id]
  
  next_group_id = group_id.to_i + 1;

  answers = params[:answers]

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

get '/resources/risk-factors/?:group_id?' do
  
  @@page_title = "Risk Factors | " + TITLE
  
  @risk_factors = {}
  
  if !params[:group_id].nil?
    # get the specific question's risk factors, or BMI for height/weight questions
    group_id = (params[:group_id].to_i == HEIGHT_WEIGHT_GROUP_ID) ? BMI_GROUP_ID : params[:group_id]
    @questions = Question.all(:conditions => ['group_id = ?', group_id])  
  else
    # no group_id param, so just grab all the questions except the height/weight ones
    @questions = Question.all(:conditions => ['group_id != ?', HEIGHT_WEIGHT_GROUP_ID])  
  end
  
  
  
  #@risk_messages = RiskMessage.all()

  @questions.each do |question|
    group_id = question.group_id
    # index by group_id that should appear in URL for questions and linking to risk factors
    index = (question.group_id == BMI_GROUP_ID) ? HEIGHT_WEIGHT_GROUP_ID : question.group_id;
    
    @risk_factors[index] = {}
    @risk_factors[index]["question"] = question;
    @risk_factors[index]["category_id"] = question.category.category_identifier
    
#    if group_id != RACE_GROUP_ID
#      @risk_factors[index]["lower_risk_message"] = RiskMessage.first(:group_id => group_id, :risk_level_id => LOWER_RISK_LEVEL_ID)    
#      @risk_factors[index]["higher_risk_message"] = RiskMessage.first(:group_id => group_id, :risk_level_id => HIGHER_RISK_LEVEL_ID)
#    else
#      @risk_factors[index]["risk_message"] = RiskMessage.first(:group_id => group_id)
#    end    
    
    @risk_factors[index]["resources"] = Resource.all(:group_id => group_id)
    
  end


  erb "resources/risk-factors".to_sym
end

get '/resources' do
  @@page_title = "Resources | " + TITLE
  @active = "resources"
  erb "resources/index".to_sym
end

get '/resources/:view' do
  @@page_title = convert_url_phrase_to_title(params[:view]) + " | " + TITLE
  @active = "resources"
  erb "resources/#{params[:view]}".to_sym
end

get '/stories' do
  @@page_title = "Video Stories | " + TITLE
  @@share_url = request.url
  @active = "stories"
  erb "stories/index".to_sym
end

get '/stories/bc-info-1' do
  @@page_title = "Breast Cancer and Young African American Women | " + TITLE
  @@share_url = request.url
  @active = "stories"
  erb "stories/bc-info-1".to_sym
end

get '/stories/bc-info-2' do
  @@page_title = "Educate Yourself to Protect Yourself | " + TITLE
  @@share_url = request.url
  @active = "stories"
  erb "stories/bc-info-2".to_sym
end

get '/stories/:view' do
  @@page_title = convert_url_phrase_to_title(params[:view]) + " | " + TITLE
  @@share_url = request.url
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

def load_results(query_string)
  # try/catch for loading results, in case query string is not valid
  begin
    height_in_inches = nil
    weight_in_pounds = nil
    
    answer_array = query_string.split("&")
    answer_array.each do |answer|
      # splits into something like ["a0", "1,3,1"]
      # [0] is index, [1] is question_id, question_option_id, and group_id
      answer_ids_array = answer.split("=")
      
      ids = answer_ids_array[1]
      ids_array = ids.split(",")    
      
      question_id = ids_array[0]
      question_option_id = ids_array[1]
      group_id = ids_array[2]
      
      if question_id.to_i == HEIGHT_QUESTION_ID
        height_question_option = QuestionOption.get(question_option_id)
        height_in_inches = height_question_option.option_choice.option_choice_value
      end
      
      if question_id.to_i == WEIGHT_QUESTION_ID
        weight_question_option = QuestionOption.get(question_option_id)
        weight_in_pounds = weight_question_option.option_choice.option_choice_value
      end
      
      # create an answer for this session using the data in the query string
      Answer.create(:session_id => @session.id, :question_id => question_id, :question_option_id => question_option_id, :group_id => group_id)
    end
    
    if !height_in_inches.nil? && !weight_in_pounds.nil?
      @session.bmi = calculate_bmi(weight_in_pounds, height_in_inches)
    end    
  rescue StandardError => err
    puts "There is a problem with the results string: #{err}"
  end
  progress = get_progress
  
  @session.progress = progress
  @session.current_question = 1
  @session.has_viewed_results = true
  @session.save  
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

def convert_url_phrase_to_title(phrase)
  return phrase.split("-").map{ |word| word.capitalize }.join(" ") 
end

helpers do
  def prevent_widows(text)
    if text.kind_of? String
      trimmed_text = text.rstrip
      last_space_index = trimmed_text.rindex(" ")
      
      if !last_space_index.nil?
        text[last_space_index] = "&nbsp;"
      end
    end

    return text
  end
  
  def shorten_text_for_tweet(text, url)
    # the 140th character is the newline break created between text and URL
    remaining = 139 - url.length
    return text.slice(0, remaining)
  end
end