require 'dm-core'
require 'dm-migrations'
require './main'
require 'dm-timestamps'
require 'sinatra/reloader'
#Sets up the connection to the database.
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/model/studentdatabase.db")

#Student class for data mapper
class Student
  include DataMapper::Resource
  
  property :id, Serial
  property :fname, String
  property :lname, String
  property :birthday, String
  property :address, String
  property :emailId, String
  property :created_at, DateTime
end

#Saves the changes for the database
DataMapper.finalize
DataMapper.auto_migrate!

#Lists all the students.
get '/students',:auth => :user do
  @students = Student.all
  erb :students
end

#Route for the new student form
get '/students/new' do
  @student = Student.new
  erb :new_student
end

#Shows a single student
get '/students/:id' do
  @student = Student.get(params[:id])
  erb :show_student
end

#Route for the form to edit a single student
get '/students/:id/edit' do
  @student = Student.get(params[:id])
  erb :edit_student
end

#Creates new student
post '/students' do
  @student = Student.create(:fname=>params[:fname],:lname=>params[:lname],:birthday=>params[:birthday],:address=>params[:address],:emailId=>params[:emailId])
  redirect to('/students')
end

#Edits a single student
post '/students/:id' do
  @student = Student.get(params[:id])
  @student.update(params[:student])
  erb :show_student
end

#Deletes a single student
delete '/students/:id' do
  Student.get(params[:id]).destroy
  redirect to('/students')
end
