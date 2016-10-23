require_relative '../app.rb'
require 'rspec'
require 'rack/test'

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

  it "should not load the index page" do
    get '/index'
    expect(last_response).to_not be_ok
  end
end
