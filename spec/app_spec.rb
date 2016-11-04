require_relative '../app.rb'
require 'rspec'
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

  it "should get 200 for messages/live" do
    get '/messages/live'
    expect(last_response).to be_ok
  end

  it "should get 200 for messages/ws" do
    get 'messages/websockets'
    expect(last_response).to be_ok
  end

end
