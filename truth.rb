require 'sinatra'
require 'sinatra/reloader'

def check_args(t, f, size)
  if size < 2
    return false
  elsif t == f
    return false
  elsif t.size > 1 || f.size > 1
    return false
  end
  true
end

def data(size)
  data = Array.new((2 ** size),0){Array.new(size,0)}
  data.each_index do |x|
    temp = x
    data[0].each_index do |y|
      if temp - (2 ** ((size-1)-y)) >= 0
        data[x][y] = 1
	temp -= (2 ** ((size-1)-y))
      end
    end
  end  
  data
end

def generate_table(t, f, size)
  data=data(size)
  (0...data.size).each do |x|
    (0...data[0].size).each do |y|
      print (data[x][y] == 1 ? "#{t}" : "#{f}")
    end
    puts
  end
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
  t_symbol, f_symbol, size = params['true'], params['false'], params['size'].to_i
  t_symbol = "T" if t_symbol == ""
  f_symbol = "F" if f_symbol == ""
  size = 3 if size == ""
  puts "true:#{t_symbol} false:#{f_symbol} size:#{size}"
  unless check_args(t_symbol, f_symbol, size)
    puts 'invalid parameters'
    erb :invalid_parameters_error
  else
    puts 'Arguments are all good'
    generate_table(t_symbol, f_symbol, size)
  end
end
