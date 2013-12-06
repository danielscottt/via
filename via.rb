require 'sinatra'
require 'yaml'
require 'haml'
require 'erb'

helpers do

  def logged_in?
    session[:user] ? true : false
  end

end
    
before /^\/*/ do
  LOGGER.info("\"#{request.ip} #{request.request_method} #{request.path_info}\" via #{request.referrer}")
end

get '/admin' do
  if logged_in?
    haml :'admin/admin'
  else
    haml :'admin/login'
  end
end

not_found do
  haml :'404'
end

error do
  haml :'500'
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
  raise Sinatra::NotFound unless logged_in?
  haml :'admin/post'
end

get '/admin/post' do
  raise Sinatra::NotFound unless logged_in?
  haml :'admin/post'
end

post '/admin/post' do
  halt 404 unless logged_in?
  post = Controller::Admin.add_post(params[:post])
  erb :'admin/post_response', :locals => {:post => post}
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

get '/blog/:year/:month/:slug' do
  post = Controller::Blog.get_single_post(params['year'], params['month'], params['slug'])
  if post
    if post.is_published? || logged_in?
      haml :'blog/single', :locals => {:post => post}
    else
      raise Sinatra::NotFound
    end
  else
    raise Sinatra::NotFound
  end
end

get '/blog/tag/:tag' do
  haml :'blog/temp', :locals => {:method => :get_posts_by_tag}
end

get '/' do
  haml :index
end

get '/blog/?' do
  haml :'blog/temp', :locals => {:method => :get_all_posts}
end
