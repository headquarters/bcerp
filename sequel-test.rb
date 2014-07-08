require 'rubygems'
require 'sinatra'
require 'sequel'

set :bind, '0.0.0.0'

enable :sessions

set :session_secret, "654654654564#%^;ljf&(aslkdfnm34)"
set :sessions, :expire_after => 2592000

DB = Sequel.sqlite('./bcerp_test.db')

DB.drop_table?(:answers, :questions, :option_choices, :question_options, :option_groups, :categories, :input_types, :sessions);

DB.create_table :sessions do
  primary_key :id
  String :session_id
end

DB.create_table :input_types do
  primary_key :id
  String :input_type_name
end

DB.create_table :categories do
  primary_key :id
  String :category_name
end

DB.create_table :option_groups do
  primary_key :id
  String :option_group_name
end

DB.create_table :option_choices do
  primary_key :id
  foreign_key :option_group_id, :option_groups
  String :option_choice_name
end

DB.create_table :questions do
  primary_key :id
  foreign_key :input_type_id, :input_types
  foreign_key :category_id, :categories
  foreign_key :option_group_id, :option_groups
  String :question_name
end

DB.create_table :question_options do
  primary_key :id
  foreign_key :question_id, :questions
  foreign_key :option_choice_id, :option_choices
end

DB.create_table :answers do
  primary_key :id
  foreign_key :session_id, :sessions, :key => :session_id
  foreign_key :question_option_id, :question_options
end

input_types = DB[:input_types]

select_id = input_types.insert(:input_type_name => "select")
checkbox_id = input_types.insert(:input_type_name => "checkbox")
radio_id = input_types.insert(:input_type_name => "radio")

categories = DB[:categories]

health_history_id = categories.insert(:category_name => "Health History")
diet_id = categories.insert(:category_name => "Diet")
exercise_id = categories.insert(:category_name => "Exercise")
environment_id = categories.insert(:category_name => "Environment")
screening_id = categories.insert(:category_name => "Screening")

option_groups = DB[:option_groups]

# insert returns id
yes_no_id = option_groups.insert(:option_group_name => "Yes/No")

option_choices = DB[:option_choices]

option_choices.insert(:option_choice_name => "Yes", :option_group_id => yes_no_id)
option_choices.insert(:option_choice_name => "No", :option_group_id => yes_no_id)

questions = DB[:questions]

questions.insert(:question_name => "Have you used birth control for 10+ years or hormone replacement therapy for 5+ years?",
                 :input_type_id => radio_id, :category_id => environment_id, :option_group_id => yes_no_id)

SITE_TITLE = "TEST"

get '/' do
  questions = DB[:questions]
  @question = questions.join(:input_types, :id => :input_type_id)
                        .join(:categories, :id => :category_id).first
  erb :sequel_test
end

error do
  erb :'500'
end

not_found do
  erb :'404'
end
