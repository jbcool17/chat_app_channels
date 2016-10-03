require 'sinatra'
require 'sinatra/contrib'
require './lib/chat'
require 'sinatra-websocket'

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
	post '/lr/user' do
		lr_chatter.write_to_csv(Time.now, "STATUS", "#{user_strong_params.upcase} HAS JOINED THE CHANNEL")
		redirect "/lr/chat/#{user_strong_params}"
	end

	get '/lr/chat/:user' do
		@user = user_strong_params
		@chat = lr_chatter.parse_csv

		erb :chat
	end

	post '/lr/:user/message' do
		lr_chatter.write_to_csv(Time.now, user_strong_params, message_strong_params)
	end

	#--------------
	# WEBSOCKETS
	#--------------
	post '/ws' do
		redirect "/ws/#{user_strong_params}"
	end

	get '/ws/:user' do
		@user = user_strong_params
	  if !request.websocket?
	    erb :ws
	  else
	    request.websocket do |ws|
	      ws.onopen do
	        settings.sockets << ws
	        ws_chatter.write_to_csv(Time.now, "STATUS", "#{user_strong_params.upcase} HAS JOINED THE CHANNEL")
	        EM.next_tick { settings.sockets.each{|s| s.send("#{Time.now},STATUS,#{@user.upcase} JOINED CHANNEL") } }
	      end

	      ws.onmessage do |msg|
	      	ws_chatter.write_to_csv(msg.split(',')[0], @user, html_safe(msg.split(',')[2]).strip)
	      	
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