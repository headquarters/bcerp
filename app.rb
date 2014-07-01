require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'json'

set :bind, '0.0.0.0'

enable :sessions

set :session_secret, "38947fm3#%^;ljf&(aslkdfnm34)"
set :sessions, :expire_after => 2592000

configure :development do
  DataMapper::Logger.new($stdout, :debug)
end

DataMapper.setup(:default, 'sqlite:bcerp.db')

class Session
  include DataMapper::Resource

  property :id, Serial
  property :session_id, String, :length => 128
  property :age, Integer
  property :race_ethnicity, String
  property :first_child, String
  property :breast_feeding_months, String
  property :relatives, String
  property :height, Integer
  property :weight, Integer
  property :bmi, Float
  property :diet_habits, String
  property :fresh_or_frozen, String
  property :charred_meat, String
  property :alcohol, String
  property :days_of_exercise, Integer
  property :fragrances, String
  property :plastic_or_glass, String
  property :hormones, String
  property :look_and_feel, String
  property :talked_to_physician, String
  property :breast_exams, String
  property :progress, Float, :default => 0
  property :created_at, DateTime
end

# DataMapper.finalize.auto_migrate! # auto_migrate clears all the data from the database
DataMapper.finalize.auto_upgrade! # auto_upgrade tries to reconcile existing database with schema changes

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

QUESTIONS = [:age, :race_ethnicity, :first_child, :breast_feeding_months, :relatives, :bmi, :diet_habits, :fresh_or_frozen, :charred_meat, :alcohol,
   :days_of_exercise, :fragrances, :plastic_or_glass, :hormones, :look_and_feel, :talked_to_physician, :breast_exams]

get '/' do
  # "Session: #{@session.session_id}"
  @active = "home"
  if params[:alt_nav]
    erb :home, :layout => :alt_nav_layout
  else
    erb :home  
  end
end

get '/questionnaire' do
  @active = "questionnaire"
  # if user has started filling out the questionnaire (progress > 0), go to first unanswered question
  if @session.progress > 0
    QUESTIONS.each do |q|
      if @session[q].nil?
        if [:look_and_feel, :talked_to_physician, :breast_exams].include?(q)
          redirect "/questionnaire/screening"
        else
          redirect "/questionnaire/#{q}"
        end
      end      
    end
  end
  
  erb :intro
end

# last question links to /questionnaire/results
# all other links point to /results
["/results", "/questionnaire/results"].each do |path|
  get path do
    @active = "questionnaire"
    
    erb :results
  end
end

get '/questionnaire/:question' do
  @progress = @session.progress.round()
  
  # keep the same nav item active the whole way through
  @active = "questionnaire"
  
  # render the template corresponding to the question
  erb "questions/#{params[:question]}".to_sym  
end

post '/questionnaire/:question' do
  # :question is named the same as the column in the Session row
  
  # e.g. :question => "age"
  question_name = params[:question]
  
  # e.g. input name="age"
  answer = params[question_name]
  
  # TODO: if the first_child is answered as "No Children", skip the breast feeding question, but
  # put the same high risk answer there???
  
  # 3 answers are POSTed for this "screening" question
  #if question_name == "screening"
  #  @session.look_and_feel = params[:look_and_feel]
  #  @session.talked_to_physician = params[:talked_to_physician]
  #  @session.breast_exams = params[:breast_exams]
  #els
  if question_name == "bmi"
    
    height_in_inches = params[:height]
    weight_in_pounds = params[:weight]
    
    @session.height = height_in_inches
    @session.weight = weight_in_pounds
    
    if height_in_inches.size > 0 && weight_in_pounds.size > 0
      bmi = calculate_bmi(weight_in_pounds, height_in_inches)  
      @session.bmi = bmi
    end
  else
    @session[question_name] = answer
  end
  
  number_complete = get_number_complete
  
  progress = number_complete * INCREMENT
  
  @session.progress = progress
  
  did_save = @session.save
  
  if request.xhr?
    content_type :json
    { :status => did_save, :progress => progress.round() }.to_json
  else
    redirect "/questionnaire/#{params[:next_question]}"
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

# TODO: need custom 404 and 500 views

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

def get_number_complete
  number_complete = 0
  
  QUESTIONS.each do |col|
    if !@session[col].nil?
      number_complete = number_complete + 1
    end
  end
  
  return number_complete
end

def calculate_bmi(weight_in_pounds, height_in_inches)
  # coerce values to float to force float division, rather than integer division
  return ((weight_in_pounds.to_f/height_in_inches.to_f**2) * 703).round(2)
end
