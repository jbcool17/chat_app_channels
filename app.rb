require 'sinatra'
require 'sinatra/contrib'
require 'sinatra-websocket'
require 'sinatra/activerecord'
require "sinatra/reloader"

require 'json'

require './lib/chat'
Dir["./models/*.rb"].each {|file| require file }

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

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

    user = User.find_or_create_by(name: user_strong_params)
    channel = Channel.find_or_create_by(name: channel_strong_params)

    App::Chat.write_data(Time.now,
                          "#{user.name.upcase} HAS CREATED CHANNEL: #{channel.name.upcase}",
                          User.find_by(name: 'STATUS').id,
                          channel.id)

    redirect "/chat/#{channel_strong_params}/#{user_strong_params}"
  end

  get '/chat/:channel/:user' do

    @user = User.find_by(name: user_strong_params)
    @status_user = User.find_by(name: 'STATUS')
    @current_channel = Channel.find_by(name: channel_strong_params)
    @channels = Channel.all


    if !request.websocket?

      erb :channel

    else
      request.websocket do |ws|

        @con = {channel: @current_channel.name, socket: ws}
      # OPEN
        ws.onopen do
          settings.sockets << @con
          time = Time.now
          message = "#{user_strong_params.upcase} HAS JOINED THE CHANNEL"

          App::Chat.write_data(time,
                                message,
                                @status_user.id,
                                @current_channel.id)

          return_array = []
          settings.sockets.each do |hash|
            if hash[:channel] == @current_channel.name
              return_array << hash
            else
              puts "[#{Time.now}] - No Channel Found."
            end
          end

          rebuilt_msg = [time,@status_user.name,message,@status_user.color].join(',')
          EM.next_tick { return_array.each{|s| s[:socket].send(rebuilt_msg) } }
        end
      # ON MESSAGE
        ws.onmessage do |msg|

          return_array = []
          settings.sockets.each do |hash|
            if hash[:channel] == @current_channel.name
              return_array << hash
            else
              puts "[#{Time.now}] - No Channel Found."
            end
          end

          # Setup Variables
          date = msg.split(',')[0]
          message = html_safe(msg.split(',')[2]).strip

          if ( message != 'ping')
            App::Chat.write_data(date,message,@user.id,@current_channel.id)
          end

            # Rebuild a String for Sockets - (date,user,message,color)
            rebuilt_msg = [date,@user.name,message,@user.color].join(',')

            EM.next_tick { return_array.each{|s| s[:socket].send(rebuilt_msg) } }
          # end
        end
      # ON CLOSE
        ws.onclose do
          warn("websocket #{ws.request['path']} closed...")
          return_array = []

          settings.sockets.each do |hash|
            if hash[:channel] == @current_channel.name
              return_array << hash
            else
              puts "[#{Time.now}] - No Channel Found."
            end
          end

          settings.sockets.each do |hash|
            if hash[:socket] == ws
              settings.sockets.delete(hash)
              puts "[#{Time.now}] - #{hash[:socket].request['path']} - deleted"

              App::Chat.write_data(Time.now,"#{@user.name.upcase} HAS LEFT THE CHANNEL",
                                    @status_user.id,@current_channel.id)

              # Rebuild a String for Sockets - (date,user,message,color)
              rebuilt_msg = [Time.now,"STATUS","#{@user.name.upcase} HAS LEFT THE CHANNEL",@status_user.color].join(',')

              EM.next_tick { return_array.each{|s| s[:socket].send(rebuilt_msg) } }
            else
              puts "[#{Time.now}] - #{hash[:socket].request['path']} - not deleted"
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
    json Channel.get_messages_for_channel(channel_strong_params)
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
