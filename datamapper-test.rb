require 'rubygems'
require 'sinatra'
require 'data_mapper'

set :bind, '0.0.0.0'

enable :sessions

set :session_secret, "654654654564#%^;ljf&(aslkdfnm34)"
set :sessions, :expire_after => 2592000

configure :development do
  DataMapper::Logger.new($stdout, :debug)
end

DataMapper.setup(:default, 'sqlite:bcerp_test.db')

# has n, means this table has foreign key in other table
# belongs_to, means this table has foreign keys from another table

class Session
  include DataMapper::Resource

  property :id, Serial  
  property :session_id, String, :length => 128
  property :bmi, Float
  property :progress, Float, :default => 0  
  property :has_viewed_results, Boolean, :default => false
  property :created_at, DateTime
  
  has n, :answer
end

class InputType
  include DataMapper::Resource
  
  property :id, Serial
  property :input_type_name, String
  
  has n, :question
end


class Category
  include DataMapper::Resource
  
  property :id, Serial
  property :category_name, String
  
  has n, :question
end

=begin
class OptionGroup
  include DataMapper::Resource
  
  property :id, Serial
  property :option_group_name, String
  
  has n, :question
  has n, :option_choice
end
=end

class RiskLevel
  include DataMapper::Resource
  
  property :id, Serial
  property :risk_level_name, String
  property :risk_level_identifier, String
  
  has n, :question_option
end

class RiskMessage
  include DataMapper::Resource
  
  property :id, Serial
  property :message, String, :length => 256
  
  has n, :question_option
end

class OptionChoice
  include DataMapper::Resource
  
  property :id, Serial
  property :option_choice_name, String
  
  has n, :question_option
end

class QuestionOption
  include DataMapper::Resource
  
  property :id, Serial
  
  has n, :answer
  belongs_to :question
  belongs_to :option_choice
  belongs_to :risk_level
  belongs_to :risk_message
end

class Question
  include DataMapper::Resource
  
  property :id, Serial
  property :question_name, String, :length => 128
  property :display_order, Integer
  
  #belongs_to :option_group

  has n, :answer
  belongs_to :input_type
  belongs_to :category
end

=begin
class QuestionGroup
  include DataMapper::Resource
  
  property :id, Serial
  has n, :question
end
=end

class Answer
  include DataMapper::Resource
  
  property :id, Serial
  
  belongs_to :session
  belongs_to :question_option
  belongs_to :question
  
  property :created_at, DateTime
end

rebuild_tables = true

if rebuild_tables
  DataMapper.finalize.auto_migrate! # auto_migrate clears all the data from the database
  require './schema'
else
  DataMapper.finalize.auto_upgrade! # auto_upgrade tries to reconcile existing database with schema changes
end

  
SITE_TITLE = "TEST"

before do
  # get the first session with this session_id or just create it and return that session row
  @session = Session.first_or_create(:session_id => session.id)
end
get '/' do
  "hello world"
end

get '/question/:id' do
  question_id = params[:id]
  
  @question = Question.get(question_id)
  
  @question_options = QuestionOption.all(:question_id => question_id)
  
  # show height and weight questions on one page
  if question_id == "6"
    @question += Question.get(7)
  end
  
  
  @answer = Answer.first(:session_id => @session.id, :question_id => question_id)
  
  erb :datamapper_test
end

post '/question/:id' do
  question_id = params[:id]
  
  question_option_id = params[:answer]
  
  if !question_option_id.nil?
    answer = Answer.first_or_new(:session_id => @session.id, :question_id => question_id)
    answer.session = @session
    answer.question_option = QuestionOption.get(question_option_id)
    answer.save
  end  
  
  redirect "/question/#{params[:id]}"
end

error do
  erb :'500'
end

not_found do
  erb :'404'
end
