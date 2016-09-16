require 'sinatra'
require './lib/chat'

set :public_folder, File.dirname(__FILE__) + '/static'

# Initialize Chat Functionallity
chatter = App::Chat.new

# HOME PAGE
get '/' do
	erb :index
end

# GET FOR USER
post '/user' do
	chatter.write_to_csv "STATUS", "#{user_strong_params.upcase} HAS JOINED THE CHANNEL"

	redirect "/chat/#{user_strong_params}"
end

# CHAT per User
get '/chat/:user' do
	@user = user_strong_params
	@chat = chatter.parse_csv
	erb :chat
end

# CHAT POST METHOD - WITH USER
post '/:user/message' do
	# Executing chat
	chatter.write_to_csv user_strong_params, message_strong_params

	redirect "/chat/#{user_strong_params}"
end

private
def user_strong_params
    html_safe(params[:user]).strip
end

def message_strong_params
	html_safe(params[:message]).strip
end
 
def html_safe(text)
  Rack::Utils.escape_html(text)
end

