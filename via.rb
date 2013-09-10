require 'sinatra'
require 'yaml'
require 'haml'

helpers do

  def logged_in?
    session[:user] ? true : false
  end

end
    


get '/admin' do
  if logged_in?
    haml :'admin/admin'
  else
    haml :'admin/login'
  end
end

post '/admin' do
  result = Controller::Admin.login(params[:post])
  if result[:response] == 'success' 
    session[:user] = result['user']
    redirect to('/admin')
  else
    haml :'admin/login', :locals => {:result => result[:response]}
  end
end

get '/admin/post/:year/:month/:slug' do
  halt 404 unless logged_in?
  haml :'admin/post'
end

get '/admin/post' do
  halt 404 unless logged_in?
  haml :'admin/post'
end

post '/admin/post' do
  halt 404 unless logged_in?
  Controller::Admin.add_post(params[:post])
  redirect to('/admin')
end

get '/admin/:year/:month/:slug/delete/confirm' do
  halt 404 unless logged_in?
  haml :'admin/ajax/confirm'
end

post '/admin/post/:id/delete' do
  halt 404 unless logged_in?
  Controller::Admin.delete_post(params)
  redirect to('/admin')
end

get '/:year/:month/:slug' do
  haml :'blog/single'
end

get '/tag/:tag' do
  haml :'blog/temp', :locals => {:method => :get_posts_by_tag}
end

get '/' do
  haml :'blog/temp', :locals => {:method => :get_all_posts}
end
