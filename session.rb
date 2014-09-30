enable :sessions

set :session_secret, "<insert your session key here>"
set :sessions, :expire_after => 2592000