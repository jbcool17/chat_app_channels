require 'sinatra'
require 'sinatra/contrib'
require 'sinatra-websocket'
require 'sinatra/activerecord'
require 'json'

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

    @user = User.find_by(name: user_strong_params)

    # ws_chatter.set_user_color(user_strong_params)
    @user_color = @user.color

    if !request.websocket?

      erb :ws_chat

    else
      request.websocket do |ws|
        ws.onopen do
          settings.sockets << ws
          puts ws.request['path']
          puts settings.sockets.count
          time = Time.now
          user = 'STATUS'
          message = "#{user_strong_params.upcase} HAS JOINED THE CHANNEL"
          color = '#D3D3D3'

          Message.create(date: time,user: user,message: message,color: color,channel_name: channel_strong_params)

          EM.next_tick { settings.sockets.each { |s| s.send("#{time},#{user},#{message},#{color}") } }
        end

        ws.onmessage do |msg|
          # Setup Variables
          date = msg.split(',')[0]
          message = html_safe(msg.split(',')[2]).strip
          color = @user_color

          if ( msg.split(',')[0] != 'ping')

            Message.create(date: date,
                            user: @user.name,
                            message: message,
                            color: color,
                            channel_name: channel_strong_params)

            # Rebuild a String for Sockets - (date,user,message,color)
            rebuilt_msg = [date,@user.name,message,color].join(',')

            EM.next_tick { settings.sockets.each{|s| s.send(rebuilt_msg) } }
          end
        end

        ws.onclose do
          warn("websocket #{ws} closed...")
          settings.sockets.delete(ws)
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
