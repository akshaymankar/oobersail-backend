require 'sinatra'
require 'rest-client'
require 'yaml'
require 'erb'

ENV['RACK_ENV'] ||= 'development'
config = YAML.load(ERB.new(File.read('config.yml')).result)[ENV['RACK_ENV']]

get '/' do
  halt 400, "Bad Request" unless params[:code]
  data = {
    client_secret: config[:client_secret],
    client_id: config[:client_id],
    grant_type: 'authorization_code',
    redirect_uri: config[:redirect_uri],
    code: params[:code],
    multipart: true
  }
  response = RestClient.post 'https://login.uber.com/oauth/v2/token', data
  response.body
end
