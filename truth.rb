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

def and_op(row)
  temp = true
  row.each do |y|
    temp = temp && y
  end
  temp
end

def or_op(row)
  temp = false
  row.each do |y|
    temp = temp || y
  end
  temp
end

def operations(data, size)
  data.each_index do |x|
    data[x][size] = and_op(data[x])
    data[x][size+1] = or_op(data[x])
    data[x][size+2] = !and_op(data[x])
    data[x][size+3] = !or_op(data[x])
  end
  data
end

def data(size)
  data = Array.new((2 ** size), false){Array.new(size, false)}
  data.each_index do |x|
    temp = x
    data[0].each_index do |y|
      if temp - (2 ** ((size-1)-y)) >= 0
        data[x][y] = true
	temp -= (2 ** ((size-1)-y))
      end
    end
  end  
  data
end

def generate_table(t, f, size)
  data=data(size)
  operations = operations(data, size) 
  operations.each_index do |x|
    operations[x].each_index do |y|
      operations[x][y] = ( operations[x][y] ? "#{t}" : "#{f}")
    end
  end
  operations
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
  size = 3 if size == 0
  puts "true:#{t_symbol} false:#{f_symbol} size:#{size}"
  unless check_args(t_symbol, f_symbol, size)
    puts 'invalid parameters'
    erb :invalid_parameters_error
  else
    puts 'Arguments are all good'
    table = generate_table(t_symbol, f_symbol, size)
    erb :output, :locals => {size: size, chart: table}
  end
end
