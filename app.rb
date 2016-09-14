require 'sinatra'
require './lib/chat'

get '/' do
	#'Hello Please Enter a User Name.'
	erb :index
end

get '/chat' do
	# create method in class to parse
	@chat = Chat.new.read_file.split("\n")
	erb :chat
end


post '/message' do

	Chat.new.append_to_txt_file "post test - #{params[:message]}"

	redirect '/chat'
end

