require 'sinatra'
require 'sinatra/contrib'
require 'sinatra-websocket'
require 'sinatra/activerecord'
require 'json'
require 'pry'

require './lib/chat'
require './models/message'
require './models/user'
require './models/channel'

class Application < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :server, 'thin'
  set :sockets, []
  set :public_folder, File.dirname(__FILE__) + '/static'
  set :database_file, 'config/database.yml'

  #----------
  # HOME PAGE
  #----------
  get '/' do
    @channels = Channel.all

    erb :index
  end

  #--------------
  # WEBSOCKETS
  #--------------
  # User Enters / Chat Area - Websockets
  post '/chat/:channel/:user' do
    if ( !User.find_by(name: user_strong_params) )
      User.create name: user_strong_params, color: App::Chat.get_color
    end
    if (!Channel.find_by(name: channel_strong_params))
      Channel.create name: channel_strong_params
    end

    redirect "/chat/#{channel_strong_params}/#{user_strong_params}"
  end

  get '/chat/:channel/:user' do

    @channels = Channel.all
    @user = User.find_by(name: user_strong_params)
    @status_user = User.find_by(name: 'STATUS')
    @channel = Channel.find_by(name: channel_strong_params)
    @user_color = @user.color

    if !request.websocket?

      erb :channel

    else
      request.websocket do |ws|

        @con = {channel: @channel.name, socket: ws}

        ws.onopen do
          settings.sockets << @con
          time = Time.now
          user = 'STATUS'
          message = "#{user_strong_params.upcase} HAS JOINED THE CHANNEL"
          color = '#D3D3D3'

          Message.create(date: time,
                          message: message,
                          user_id: @status_user.id,
                          channel_id: @channel.id)

          return_array = []
          settings.sockets.each do |hash|
            if hash[:channel] == @channel.name
              return_array << hash
            else
              puts "No Channel Found."
            end
          end
          puts "OPEN--------------------"
          # EM.next_tick { return_array.each { |s| s[:socket].send("#{time},#{@status_user.name},#{message},#{color}") } }
        end

        ws.onmessage do |msg|

          return_array = []
          settings.sockets.each do |hash|
            if hash[:channel] == @channel.name
              return_array << hash
            else
              puts "No Channel Found."
            end
          end

          # Setup Variables
          date = msg.split(',')[0]
          message = html_safe(msg.split(',')[2]).strip
          color = @user_color

          if ( message != 'ping')

            Message.create(date: date,
                            message: message,
                            user_id: @user.id,
                            channel_id: @channel.id)

            # Rebuild a String for Sockets - (date,user,message,color)
            rebuilt_msg = [date,@user.name,message,color].join(',')

            EM.next_tick { return_array.each{|s| s[:socket].send(rebuilt_msg) } }
          end
        end

        ws.onclose do
          warn("websocket #{ws.request['path']} closed...")

          settings.sockets.each do |hash|
            if hash[:socket] == ws
              settings.sockets.delete(hash)
              puts "#{hash[:socket].request['path']} - deleted"
            else
              puts "#{hash[:socket].request['path']} - not deleted"
            end
          end

        end
      end
    end
  end

  #----------------------
  # GET MESSAGES via JSON
  #----------------------
  get '/messages/:channel' do
    json Channel.find_by(name: channel_strong_params).messages.map {|m| {date: m.date, message: m.message, user: m.user.name, color: m.user.color }}
  end

  get '/messages' do
    json Message.all
  end

  get '/users' do
    json User.all
  end

  get '/users/:user' do
    json User.find_by(name: user_strong_params).messages
  end

  get '/channels' do
    json Channel.all
  end

  private
  # Cleaning Up User Input for DB
  def user_strong_params
    html_safe(params[:user]).strip
  end

  def channel_strong_params
    html_safe(params[:channel]).strip
  end

  def message_strong_params
    html_safe(params[:message]).strip
  end

  def html_safe(text)
    Rack::Utils.escape_html(text)
  end
end
