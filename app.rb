require 'sinatra'
require './lib/chat'

get '/' do
	#'Hello Please Enter a User Name.'
	erb :index
end

get '/chat' do
	#'This is a chat.'
	@test = Chat.new.read_file.split("\n")
	erb :chat
end


