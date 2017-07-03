require 'uri'
require 'net/http'
require 'yaml'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: batch_uploader.rb [options]"

  opts.on("-a", "--all", "Batch upload all files in current directory") do |v| 
    options[:all] = v 
  end 
  opts.on("-f", "--file file", "Upload an individual file") do |f| 
    options[:file] = f 
  end 
  opts.on("-d", "--dir directory", "Upload all files in a directory") do |d| 
    options[:dir] = d 
  end 
  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end 
end.parse!

if options.empty?
  # Process All In current directory
  puts "Processing All"
  Dir.glob('*') do |file|
    if File.file?(file)
      # UPLOAD FILE
    end 
  end 
elsif options.include?(:dir)
  # Process All in different directory
  puts "Processing All"
  Dir.glob("#{options[:dir]}/*") do |file|
    if File.file?(file_name)
      # UPLOAD FILE
    end
  end 
elsif options.include?(:file)
  # Process Single file
  file_name = options[:file]
  puts "Processing #{file_name}"
  if File.file?(file_name)
    # UPLOAD FILE
  end

  file = File.open(file_name)
  byte_representation = file.read

  # split_name = file_name
  # split_name.split("/")[-1]

  user = YAML.load_file(File.dirname(__FILE__) + "/users_example.yml")
  auth = user[1]["auth_token"]

  url = URI("http://localhost:3000/projects/8/attachments.json?auth_token=#{auth}")

  http = Net::HTTP.new(url.host, url.port)

  request = Net::HTTP::Post.new(url)
  request["content-type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
  request["cache-control"] = 'no-cache'
  request["postman-token"] = '928ab48e-9553-49c0-c651-7e6577b19e6c'
  request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"attachment[attachment]\"; filename=\"#{file_name}\"\r\nContent-Type: image/jpeg\r\n\r\n#{byte_representation}\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
	
  response = http.request(request)
  puts response.read_body
  puts response.code
	
end
