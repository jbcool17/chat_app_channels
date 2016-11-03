require 'sinatra'
require 'sinatra/contrib'
require 'sinatra-websocket'
require 'sinatra/activerecord'
require 'json'

require './lib/chat'
require './models/message'

class Application < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :server, 'thin'
  set :sockets, []
  set :public_folder, File.dirname(__FILE__) + '/static'
  set :database_file, 'config/database.yml'

  # Initialize Chat Functionality
  ws_chatter = App::Chat.new('websockets')
  lr_chatter = App::Chat.new('live')
  mr_chatter = App::Chat.new('manual')

  #----------
  # HOME PAGE
  #----------
  get '/' do
    erb :index
  end

  #----------
  # React - Setup based on tutorial - FOR TESTING
  #----------
  get '/react' do
    erb :test_react
  end

  get '/api/comments' do
    comments = JSON.parse(File.read('./static/comments.json',
                                    encoding: 'UTF-8'))

    json comments
  end
  post '/api/comments' do
    comment = {}
    comments = JSON.parse(File.read('./static/comments.json',
                                    encoding: 'UTF-8'))

    comment[:id] = (Time.now.to_f * 1000).to_i
    comment[:author] = params['author']
    comment[:text] = params['text']

    comments << comment

    File.write('./static/comments.json',
               JSON.pretty_generate(comments, indent: '    '),
               encoding: 'UTF-8')

    json comments
  end

  #--------------
  # Manual RELOAD
  #--------------
  # User Enters / Chat Area / Post Message
  get '/mr/:user' do
    mr_chatter.write_data(Time.now,
                          'STATUS',
                          "#{user_strong_params.upcase} HAS JOINED THE CHANNEL",
                          mr_chatter.chat_name)

    mr_chatter.set_user_color(user_strong_params)

    redirect "/mr/chat/#{user_strong_params}"
  end

  get '/mr/chat/:user' do
    @user = user_strong_params
    @chat = Message.manual

    erb :mr_chat
  end

  post '/mr/:user/message' do
    mr_chatter.write_data(Time.now,
                          user_strong_params,
                          message_strong_params,
                          mr_chatter.chat_user_list[user_strong_params],
                          mr_chatter.chat_name)

    redirect "/mr/chat/#{user_strong_params}"
  end

  #--------------
  # LIVE RELOAD
  #--------------
  # User Enters / Chat Area / Post Message
  get '/lr/:user' do
    lr_chatter.write_data(Time.now,
                          'STATUS',
                          "#{user_strong_params.upcase} HAS JOINED THE CHANNEL",
                          lr_chatter.chat_name)

    lr_chatter.set_user_color(user_strong_params)

    redirect "/lr/chat/#{user_strong_params}"
  end

  get '/lr/chat/:user' do
    @user = user_strong_params
    @chat = Message.live

    erb :lr_chat
  end

  post '/lr/:user/message' do
    lr_chatter.write_data(Time.now,
                          user_strong_params,
                          message_strong_params,
                          lr_chatter.chat_user_list[user_strong_params],
                          lr_chatter.chat_name)
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
    @user_color = ws_chatter.chat_user_list[@user]

    if !request.websocket?

      erb :ws_chat

    else
      request.websocket do |ws|
        ws.onopen do
          settings.sockets << ws

          time = Time.now
          user = 'STATUS'
          message = "#{user_strong_params.upcase} HAS JOINED THE CHANNEL"
          color = '#D3D3D3'

          ws_chatter.write_data(time,user,message,color,ws_chatter.chat_name)

          EM.next_tick { settings.sockets.each { |s| s.send("#{time},#{user},#{message},#{color}") } }
        end

        ws.onmessage do |msg|
          # Setup Variables
          date = msg.split(',')[0]
          message = html_safe(msg.split(',')[2]).strip
          color = @user_color

          if ( msg.split(',')[0] != 'ping')

            ws_chatter.write_data(date,
                                  @user,
                                  message,
                                  color,
                                  ws_chatter.chat_name)

            # Rebuild a String for Sockets - (date,user,message,color)
            rebuilt_msg = [date,@user,message,color].join(',')

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
  get '/messages/live' do
    json Message.live.as_json
  end

  get '/messages/websockets' do
    json Message.websockets.as_json
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
