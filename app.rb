require 'sinatra'
require 'sinatra/contrib'
require 'sinatra-websocket'
require './lib/chat'

class Application < Sinatra::Base

	set :server, 'thin'
	set :sockets, []
	set :public_folder, File.dirname(__FILE__) + '/static'

	# Initialize Chat Functionality
	ws_chatter = App::Chat.new("websockets")
	lr_chatter = App::Chat.new("live_reload")
	mr_chatter = App::Chat.new("manual_reload")

	#----------
	# HOME PAGE
	#----------
	get '/' do
		erb :index
	end

	#--------------
	# Manual RELOAD
	#--------------
	# User Enters / Chat Area / Post Message
	post '/mr/user' do
		mr_chatter.write_to_csv(Time.now, "STATUS", "#{user_strong_params.upcase} HAS JOINED THE CHANNEL")
		redirect "/mr/chat/#{user_strong_params}"
	end

	get '/mr/chat/:user' do
		@user = user_strong_params
		@chat = mr_chatter.parse_csv

		erb :mr_chat
	end

	post '/mr/:user/message' do
		mr_chatter.write_to_csv(Time.now, user_strong_params, message_strong_params)
		redirect "/mr/chat/#{user_strong_params}"
	end

	#--------------
	# LIVE RELOAD
	#--------------
	# User Enters / Chat Area / Post Message
	post '/lr/user' do
		user = user_strong_params
		
		lr_chatter.write_to_csv(Time.now, "STATUS", "#{user.upcase} HAS JOINED THE CHANNEL")
		redirect "/lr/chat/#{user}"
		
	end

	get '/lr/chat/:user' do
		@user = user_strong_params
		@chat = lr_chatter.parse_csv

		erb :lr_chat
	end

	post '/lr/:user/message' do
		lr_chatter.write_to_csv(Time.now, user_strong_params, message_strong_params)
	end

	#--------------
	# WEBSOCKETS
	#--------------
	# User Enters / Chat Area - Websockets
	post '/ws' do
		redirect "/ws/#{user_strong_params}"
	end

	get '/ws/:user' do
		
		@user = user_strong_params
		ws_chatter.set_user_color(user_strong_params)
		@current_ws_users = ws_chatter.chat_user_list
		@user_color = ws_chatter.chat_user_list[@user]

	  if !request.websocket?
	    erb :ws_chat
	  else
	    request.websocket do |ws|
	      ws.onopen do
	        settings.sockets << ws

	        ws_chatter.write_to_csv(Time.now, "STATUS", "#{user_strong_params.upcase} HAS JOINED THE CHANNEL", "#FF4000")

	        EM.next_tick { settings.sockets.each{|s| s.send("#{Time.now},STATUS,#{@user.upcase} HAS JOINED THE CHANNEL,#FF4000") } }
	      end

	      ws.onmessage do |msg|
	      	if ( msg.split(',')[0] != 'ping')
	      		ws_chatter.write_to_csv(msg.split(',')[0], @user, html_safe(msg.split(',')[2]).strip, ws_chatter.chat_user_list[@user])
	      		
	      		# cleaning up for storage 
	      		msg = [msg.split(',')[0], msg.split(',')[1], html_safe(msg.split(',')[2]).strip, msg.split(',')[3]].join(',')
	      	
	        	EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
	        end
	      end

	      ws.onclose do
	        warn("websocket closed...")
	        settings.sockets.delete(ws)
	      end
	    end
	  end
	end

	#----------------------
	# GET MESSAGES via JSON
	#----------------------
	get '/messages/live_reload' do
		json lr_chatter.parse_csv
	end

	get '/messages/websockets' do
		json ws_chatter.parse_csv
	end
	get '/messages/manual_reload' do
		json mr_chatter.parse_csv
	end

	private
	# Cleaning Up User Input for DB
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