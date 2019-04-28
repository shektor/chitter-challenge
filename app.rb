require 'sinatra/base'
require './lib/user'
require './db/database_connection_setup'

class ChitterManager < Sinatra::Base

  enable :sessions

  get '/' do
    'Hello World'
  end

  get '/chitters' do
    @user = User.find(session[:id])
    erb :'chitters/index'
  end

  get '/users/new' do
    erb :'users/sign_up'
  end

  post '/users' do
    @user = User.create(
      name: params[:name],
      username: params[:username],
      email: params[:email],
      password: params[:password]
    )
    session[:id] = @user.id
    redirect '/chitters'
  end

  run! if app_file == $0
end