require_relative '../app.rb'
require 'rspec'
require 'open-uri'
require 'rack/test'
require 'json'

set :environment, :test

describe 'Server Service' do
  include Rack::Test::Methods

  def app
    Application.new
  end

  it "should load the index page" do
    get '/'
    expect(last_response).to be_ok
  end

  it "should redirect to chat channel" do
    post '/chat/test_channel/test_user'

    expect(last_request.url).to eq("http://example.org/chat/test_channel/test_user")
  end

# GET JSON
  it "should get 200 for /messages" do
    get '/messages'
    expect(last_response).to be_ok
  end

  it "should get 200 for /messages/:channel" do
    channel = URI::encode(Channel.first.name).strip

    get "/messages/#{channel}"
    expect(last_response).to be_ok
  end

  it "should get 200 for /users" do
    get '/users'
    expect(last_response).to be_ok
  end

  it "should get 200 for /users/:user" do
    user = User.first.name
    get "/users/#{user}"
    expect(last_response).to be_ok
  end

  it "should get 200 for /channels" do
    get '/channels'
    expect(last_response).to be_ok
  end

end
