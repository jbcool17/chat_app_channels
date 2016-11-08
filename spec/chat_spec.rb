require_relative '../lib/chat.rb'
require 'rspec'
require 'rack/test'
require 'sinatra/activerecord'
require './models/message'
require 'json'

describe 'Chat Service' do
  include Rack::Test::Methods

  it 'should get a hex color value' do
    color = App::Chat.get_color
    color.slice!(0)
    expect(!color[/\H/]).to eq true
  end

  it 'should write to the database' do
    user = User.first
    channel = Channel.first
    test = App::Chat.write_data Time.now, "this is a test", user.id, channel.id

    expect(test.message).to eq 'this is a test'
  end

end
