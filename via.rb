require 'sinatra'
require 'haml'

get '/p/:year/:month/:slug' do
  haml :'blog/single'
end

get '/login' do
  haml :'blog/login'
end

post '/login' do
  result = Controller::Blog.login(params[:post])
  if result == 'success' 
    redirect to('/')
  else
    haml :'blog/login' :locals => {:result => result}
  end
end
  
post '/add' do
  Controller::Blog.add_post(params[:post])
  redirect to('/')
end

get '/' do
  haml :'blog/temp', :locals => {:method => :get_all_posts}
end
