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
    test = App::Chat.write_data Time.now, "user_name", "this is a test", '#D3D3D3', "test"

    expect(test.message).to eq 'this is a test'
  end

end
