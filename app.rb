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
	chatter.write_to_csv "STATUS", "#{params[:user].strip.upcase} HAS JOINED THE CHANNEL"

	redirect "/chat/#{params[:user].strip}"
end

# CHAT per User
get '/chat/:user' do
	@user = params[:user].strip
	@chat = chatter.parse_csv

	erb :chat
end

# CHAT POST METHOD - WITH USER
post '/:user/message' do
	# Executing chat
	chatter.write_to_csv params[:user], params[:message].strip

	redirect "/chat/#{params[:user]}"
end

