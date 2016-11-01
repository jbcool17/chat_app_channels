require_relative '../lib/chat.rb'
require 'rspec'
require 'rack/test'
require 'sinatra/activerecord'
require './models/message'
require 'json'

describe 'Chat Service' do
  include Rack::Test::Methods

  before(:each) do
    @ws_chatter = App::Chat.new('websockets')
  end

  it 'should create new chat type' do
    expect(@ws_chatter).to eq(@ws_chatter)
  end

  it 'should create new chat type named websockets' do
    expect(@ws_chatter.chat_name).to eq('websockets')
    expect(@ws_chatter.chat_name).to_not eq('12345')
  end

  it 'should set user color' do
    color = @ws_chatter.set_user_color("user01")
    expect(color).to eq(color)
  end

  it 'should get a hex color value' do
    color = @ws_chatter.get_color
    color.slice!(0)
    expect(!color[/\H/]).to eq true
  end

  it 'should write to the database' do
    test = @ws_chatter.write_data Time.now, "user_name", "this is a test", color='#D3D3D3', "test"

    expect(test.message).to eq 'this is a test'
  end

end
