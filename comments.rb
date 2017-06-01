require 'dm-core'
require 'dm-migrations'
require './main'
require 'sinatra/reloader'
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/model/commentsdatabase.db")


#Comment class for data mapper
class Comment
  include DataMapper::Resource

  property :comid, Serial
  property :name, String
  property :com, String
  property :created_at, Time
end

#Saves the changes for the database
DataMapper.finalize
DataMapper.auto_migrate!

#Lists all the comments.
get '/comments' do
  @comments = Comment.all
  erb :comments
end

#Route for the new comment form
get '/comments/new' do
  @comment = Comment.new
  erb :new_comment 
end

#Shows a single comment
get '/comments/:comid' do
  @comment = Comment.get(params[:comid])
  erb :show_comment
end

#Route for the form to edit a single comment
get '/comments/:comid/edit' do
  @comment = Comment.get(params[:comid])
  erb :comment_edit
end

#Creates new comment
post '/comments' do
  @comment = Comment.create(params[:comment])
  redirect to('/comments')
end

#Edits a single comment
post '/comments/:comid' do
  @comment = Comment.get(params[:comid])
  @comment.update(params[:comment])
  erb :show_comment
end

#Deletes a single comment
delete '/comments/:comid' do
  Comment.get(params[:comid]).destroy
  redirect to('/comments')
end