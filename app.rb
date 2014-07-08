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

rebuild_tables = true

if rebuild_tables
  DataMapper.finalize.auto_migrate! # auto_migrate clears all the data from the database
  require './schema'
else
  DataMapper.finalize.auto_upgrade! # auto_upgrade tries to reconcile existing database with schema changes
end

before do
  # get the first session with this session_id or just create it and return that session row
  @session = Session.first_or_create(:session_id => session.id)
end

SITE_TITLE = "Breast Health Awareness"

=begin
There are 17 questions. Height and weight count as 1 question (BMI).
Each question is worth 100/17 or 5.88% of the whole questionnaire.
Use round() when displaying.
=end
INCREMENT = 5.88

get '/' do
  @active = "home"
  erb :home  
end

get '/questionnaire' do
  @active = "questionnaire"
  if !@session.current_question.nil?
    redirect "/questionnaire/#{@session.current_question}"
  else
    erb :intro
  end
end

# last question links to /questionnaire/results
# all other links point to /results
["/results", "/questionnaire/results"].each do |path|
  get path do
    @active = "questionnaire"
    
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
  
  # all questions in a group share the same category
  @category_name = @questions[0].category.category_name
  
  @question_options = {}
  
  @answers = {}
  
  @questions.each do |q|
    @question_options[q.id] = QuestionOption.all(:question_id => q.id)
    @answers[q.id] = Answer.first(:session_id => @session.id, :question_id => q.id)
  end
  
  # keep the same nav item active the whole way through
  @active = "questionnaire"
  
  erb :question
end

post '/questionnaire/:group_id' do
  group_id = params[:group_id]
  
  next_question_id = group_id.to_i + 1;

  answers = params[:answers]
  
  @session.current_question = group_id
  
  # TODO: if the first_child is answered as "No Children", skip the breast feeding question, but
  # put the same high risk answer there???

  if !answers.nil?
    answers.each do |question_id, question_option_id|
      answer = Answer.first_or_new(:session_id => @session.id, :question_id => question_id)
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
    if next_question_id < 18
      redirect "/questionnaire/#{next_question_id}"
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

get '/about' do
  @active = "about"
  erb :about
end

get '/reset' do
  # clear previous session, but leave the data in the database
  session.clear
  
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
  count = Answer.count(:session_id => @session.id)
  
  # there are only 17 questions (height and weight are 1 and BMI is not visible to users)
  if count > 17
    count = 17
  end
  
  return count * INCREMENT
end

def calculate_bmi(weight_in_pounds, height_in_inches)
  # coerce values to float to force float division, rather than integer division
  return ((weight_in_pounds.to_f/height_in_inches.to_f**2) * 703).round(2)
end
