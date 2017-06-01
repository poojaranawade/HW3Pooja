# includes the sinatra library
require 'sinatra'
#includes the scss library
require 'sass'
require 'sinatra/reloader'
#includes the student routes
require './student'
#includes the user routes
require './users'

require './comments.rb'

#defines SCSS template
get('/styles.css'){ scss :styles }

set :sessions => true

register do
  def auth (type)
    condition do
      redirect "/login" unless send("is_#{type}?")
    end
  end
end

helpers do
  def is_user?
    @user != nil
  end
end

before do
  @user = User.first(:username => session[:username])
end

get '/' do
  erb :home
end

get '/about' do
  erb :about
end

get '/contact' do
  erb :contact
end

get '/video' do
  erb :video
end

get '/comments' do
   erb :comments
end      

get '/login' do
  erb :login
end

get '/signup' do
  erb :signup
end

get '/signout' do
  erb :signout
  session[:username] = nil
  redirect to('/students')
end

post '/users' do
  @user = User.create(params[:user])
  redirect to('/students')
end

post '/login' do
  session[:username] = User.authenticate(params)
  redirect to('/students')
end

post '/logout' do
  session.clear
  redirect to('/home')
end

not_found do
  erb :not_found,:layout=>false
end
