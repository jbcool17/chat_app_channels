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

	# get '/wsalso' do
	#   if !request.websocket?
	#   	puts "WHAT HAPPENED"
	#     erb :wsalso
	#   else
	#     request.websocket do |ws|
	#       ws.onopen do
	#       	puts "OPEN"
	#         ws.send("Hello World!")
	#         settings.sockets << ws
	#       end
	#       ws.onmessage do |msg|
	#       	puts "MESS"
	#         EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
	#       end
	#       ws.onclose do
	#       	puts "CLOSEED MATE"
	#         warn("websocket closed...")
	#         settings.sockets.delete(ws)
	#       end
	#     end
	#   end
	# end

	get '/ws' do
	  if !request.websocket?
	  	puts "WHAT HAPPENED"
	    erb :ws
	  else
	    request.websocket do |ws|
	      ws.onopen do
	      	puts "OPEN"
	        settings.sockets << ws
	        ws.send("Hello World!")
	      end

	      ws.onmessage do |msg|
	      	puts "MESSAGE SENDING...MATE #{msg}"
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
		chatter.write_to_csv(user_strong_params, message_strong_params)
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