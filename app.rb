require 'sinatra'
require './lib/chat'

get '/' do
	#'Hello Please Enter a User Name.'
	erb :index
end

post '/user' do
	redirect "/chat/#{params[:user]}"
end

get '/chat/:user' do
	# create method in class to parse
	@user = params[:user]
	@chat = Chat.new.read_file.split("\n")
	erb :chat
end


post '/:user/message' do
	# Executing chat
	Chat.new.append_to_txt_file "#{params[:user]}: #{params[:message]}"

	redirect "/chat/#{params[:user]}"
end

