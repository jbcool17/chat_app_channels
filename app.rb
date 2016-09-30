require 'sinatra'
require 'sinatra/contrib'
require './lib/chat'
require 'sinatra-websocket'




class Application < Sinatra::Base

	set :server, 'thin'
	set :sockets, []
	set :public_folder, File.dirname(__FILE__) + '/static'


	# Initialize Chat Functionality
	chatter = App::Chat.new

	get '/ws/:user' do
		@user = user_strong_params
	  if !request.websocket?
	    erb :ws
	  else
	    request.websocket do |ws|
	      ws.onopen do
	        settings.sockets << ws
	      end

	      ws.onmessage do |msg|
	      	chatter.write_to_csv(msg.split(',')[0], @user, html_safe(msg.split(',')[2]).strip)
	      	
	      	# cleaning up for sockets 
	      	msg = [msg.split(',')[0], msg.split(',')[1], html_safe(msg.split(',')[2]).strip].join(',')
	        EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
	      end

	      ws.onclose do
	        warn("websocket closed...")
	        settings.sockets.delete(ws)
	      end
	    end
	  end
	end

	# HOME PAGE
	get '/' do
		erb :index
	end

	# POST FOR USER Name - Entering Chat
	post '/user' do
		chatter.write_to_csv("STATUS", "#{user_strong_params.upcase} HAS JOINED THE CHANNEL")
		redirect "/chat/#{user_strong_params}"
	end

	# CHAT - per User
	get '/chat/:user' do
		@user = user_strong_params
		@chat = chatter.parse_csv

		erb :chat
	end

	# CHAT POST METHOD
	post '/:user/message' do
		# Executing chat
		chatter.write_to_csv(Time.now, user_strong_params, message_strong_params)
	end

	# GET MESSAGES via JSON
	get '/messages' do
		json chatter.parse_csv
	end

	private
	# Cleaning Up User Input
	def user_strong_params
	    html_safe(params[:user]).strip
	end

	def message_strong_params
		html_safe(params[:message]).strip
	end
	 
	def html_safe(text)
		Rack::Utils.escape_html(text)
	end
end