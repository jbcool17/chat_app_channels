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
get '/user' do
	chatter.add_to_csv params[:user], "JOINED THE CHANNEL"
	redirect "/chat/#{params[:user]}"
end

# CHAT APP
get '/chat/:user' do
	# create method in class to parse
	@user = params[:user]
	@chat = chatter.parse_csv
	erb :chat
end

# CHAT POST METHOD - WITH USER
post '/:user/message' do
	# Executing chat
	chatter.add_to_csv params[:user], params[:message]

	redirect "/chat/#{params[:user]}"
end

