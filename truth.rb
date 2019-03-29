require 'sinatra'
require 'sinatra/reloader'

def invalid_parameters
  puts 'invalid parameters'
  erb :invalid_parameters_error
end


def check_args(t, f, size)
  puts "Value of size #{size.to_i}"
  if size.to_i < 2
    return false
  elsif t == f
    return false
  elsif t.size > 1 || f.size > 1
    return false
  end
  true
end

get '/' do
  puts 'index called'
  erb :index
end

not_found do 
  status 404
  erb :nonexistent_page_error
end

get '/table' do
  puts 'table called'
  t_symbol, f_symbol, size = params['true'], params['false'], params['size']
  unless check_args(t_symbol, f_symbol, size)
    puts 'invalid parameters'
    erb :invalid_parameters_error
    return
  end
  puts 'Arguments are all good'
end
