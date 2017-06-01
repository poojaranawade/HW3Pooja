require 'sinatra/reloader'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/studentdatabase.db")

#Student Class for data mapper
class User
  include DataMapper::Resource

  property :id, Serial
  property :username, String
  property :password, String
end

def User.authenticate(params)
  @user = User.first(:username => params[:username])

  if !@user || @user.password!=params[:password]
    puts 'not auth'
  else
    return @user.username
end

  return nil
end

#Saves the changes for the database
DataMapper.finalize
DataMapper.auto_migrate!

#Creates new user
post '/users' do
  @user = User.create(params[:user])
  redirect to('/students')
end