require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'rational'

set :bind, '0.0.0.0'

enable :sessions

set :session_secret, "38947fm3#%^;ljf&(aslkdfnm34)"
set :sessions, :expire_after => 2592000

configure :development do
  DataMapper::Logger.new($stdout, :debug)
end

# DataMapper.setup(:default, 'sqlite://#{Dir.pwd}/bcerp.db') throws an error, so do not use
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

# auto_migrate clears all the data from the database
# auto_upgrade tries to reconcile existing database with changes
# DataMapper.finalize.auto_migrate!
DataMapper.finalize.auto_upgrade!

# access session ID with session.id
before do
  # get the first session with this session_id or just create it and return that session row
  @session = Session.first_or_create(:session_id => session.id)
end

SITE_TITLE = "Breast Health Awareness"

# there are 18 questions, so each question is 5.55% of the whole thing (18 * 5.55 = 99.9, so round() when displaying)
INCREMENT = 5.55

QUESTIONS = [:age, :race_ethnicity, :first_child, :breast_feeding_months, :relatives, :height, :weight, :diet_habits, :fresh_or_frozen, :charred_meat, :alcohol,
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

get '/assessment' do
  @active = "assessment"
  # TODO: if user has started filling out the survey (progress > 0), go to first unanswered question
  if @session.progress > 0
    QUESTIONS.each do |q|
      if @session[q].nil?
        # redirect to the first unanswered question
        redirect "/assessment/#{q}"
      end      
    end
  end
  
  # TODO: what if user has completed the survey and clicks "Go Back to Survey"?
  erb :intro
end

# last question links to /assessment/results
# all other links point to /results
["/results", "/assessment/results"].each do |path|
  get path do
    @active = "assessment"
    
    erb :results
  end
end

get '/assessment/:question' do
  @progress = @session.progress.round()
  
  # keep the same nav item active the whole way through
  @active = "assessment"
  
  # render the template corresponding to the question
  erb "questions/#{params[:question]}".to_sym  
end

post '/assessment/:question' do
  # :question is named the same as the column in the Session row
  
  # e.g. :question => "age"
  question_name = params[:question]
  
  # e.g. input name="age"
  answer = params[question_name]
  
  # TODO: if the first_child is answered as "No Children", skip the breast feeding question, but
  # put the same high risk answer there???
  
  # 3 answers are POSTed for this "screening" question
  if question_name == "screening"
    progress = @session.progress
    
    @session.look_and_feel = params[:look_and_feel]
    @session.talked_to_physician = params[:talked_to_physician]
    @session.breast_exams = params[:breast_exams]

    number_complete = get_number_complete
    
    progress = number_complete * INCREMENT
    
    @session.progress = progress
    
    @session.save
  end
  
  
  # record answer in DB, along with incrementing progress
  if question_name != "screening" && !answer.nil? && !answer.empty?
    progress = @session.progress
    
    @session[question_name] = answer

    number_complete = get_number_complete
    
    progress = number_complete * INCREMENT
    
    @session.progress = progress
    
    @session.save
  end
  redirect "/assessment/#{params[:next_question]}"
end

=begin
    @session.attributes = {
      question_name.to_sym => answer,
      :progress => progress
    }
    @session.save
=end

get '/resources' do
  @active = "resources"
  erb :resources
end

get '/stories' do
  @active = "stories"
  erb :stories
end

get '/about' do
  @active = "about"
  erb :about
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