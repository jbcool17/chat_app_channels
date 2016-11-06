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

  # Initialize Chat Functionality
  # ws_chatter = App::Chat.new('websockets')
  # lr_chatter = App::Chat.new('live')
  # mr_chatter = App::Chat.new('manual')

  #----------
  # HOME PAGE
  #----------
  get '/' do
    @channels = Channel.all.to_a

    erb :index
  end

  #--------------
  # WEBSOCKETS
  #--------------
  # User Enters / Chat Area - Websockets
  post '/chat/:channel/:user' do
    chat = App::Chat.new(channel_strong_params)

    User.create name: user_strong_params, color: chat.get_color
    # Channel.create name: channel_strong_params

    redirect "/chat/#{channel_strong_params}/#{user_strong_params}"
  end

  get '/chat/:channel/:user' do

    @user = User.find_or_create_by(name: user_strong_params, color: App::Chat.new('test').get_color)
    @channel = Channel.find_or_create_by(name: channel_strong_params).name

    # ws_chatter.set_user_color(user_strong_params)
    @user_color = @user.color

    if !request.websocket?

      erb :ws_chat

    else
      request.websocket do |ws|

        @con = {channel: @channel, socket: ws}

        ws.onopen do
          settings.sockets << @con

          # puts ws.request['path']
          # puts settings.sockets.count
          time = Time.now
          user = 'STATUS'
          message = "#{user_strong_params.upcase} HAS JOINED THE CHANNEL"
          color = '#D3D3D3'

          Message.create(date: time,
                          user: user,
                          message: message,
                          color: color,
                          channel_name: @channel)

          return_array = []
          settings.sockets.each do |hash|
            if hash[:channel] == @channel
              return_array << hash
            else
              puts "No Channel Found."
            end
          end
          EM.next_tick { return_array.each { |s| s[:socket].send("#{time},#{user},#{message},#{color}") } }
        end

        ws.onmessage do |msg|

          return_array = []
          settings.sockets.each do |hash|
            if hash[:channel] == @channel
              return_array << hash
            else
              puts "No Channel Found."
            end
          end

          # Setup Variables
          date = msg.split(',')[0]
          message = html_safe(msg.split(',')[2]).strip
          color = @user_color

          if ( msg.split(',')[0] != 'ping')

            Message.create(date: date,
                            user: @user.name,
                            message: message,
                            color: color,
                            channel_name: @channel)

            # Rebuild a String for Sockets - (date,user,message,color)
            rebuilt_msg = [date,@user.name,message,color].join(',')

            EM.next_tick { return_array.each{|s| s[:socket].send(rebuilt_msg) } }
          end
        end

        ws.onclose do
          warn("websocket #{ws} closed...")

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
    json Message.where(channel_name: channel_strong_params)
  end

  get '/messages' do
    json Message.all
  end

  get '/users' do
    json User.all
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
