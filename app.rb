require 'sinatra'

get '/' do
	#'Hello Please Enter a User Name.'
	erb :index
end

get '/chat' do
	#'This is a chat.'
	erb :chat
end


