require 'sinatra'

get '/' do
	#'Hello Please Enter a User Name.'
	erb :index
end

get '/chat' do
	#'This is a chat.'
	@test = 'hello this is a test'
	erb :chat
end


