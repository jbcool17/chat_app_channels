require 'sinatra'
require './lib/chat'


# HOME PAGE
get '/' do
	erb :index
end

# POST FOR CREATING USER
post '/user' do
	redirect "/chat/#{params[:user]}"
end

# CHAT APP
get '/chat/:user' do
	# create method in class to parse
	@user = params[:user]
	@chat = Chat.new.read_file.split("\n")
	erb :chat
end

# CHAT POST METHOD - WITH USER
post '/:user/message' do
	# Executing chat
	Chat.new.append_to_txt_file "#{params[:user]}: #{params[:message]}"

	redirect "/chat/#{params[:user]}"
end

