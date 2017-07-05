require 'uri'
require 'net/http'
require 'yaml'

files = Dir.glob('*/*').select {|f| File.file? f}
puts "Processing all.. "

files.each do |fname| #iterate over each file
  file = File.open(fname)
	byte_representation = file.read

	user = YAML.load_file(File.dirname(__FILE__) + "/users_example.yml") #for authentication
	auth = user[1]["auth_token"]
	url = URI("http://localhost:3000/projects/8/attachments.json?auth_token=#{auth}")

	http = Net::HTTP.new(url.host, url.port)

	request = Net::HTTP::Post.new(url)
	request["content-type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
	request["cache-control"] = 'no-cache'
	request["postman-token"] = '928ab48e-9553-49c0-c651-7e6577b19e6c'
	request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"attachment[attachment]\"; filename=\"#{fname}\"\r\nContent-Type: image/jpeg\r\n\r\n#{byte_representation}\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
			
	response = http.request(request)
	puts response.read_body
	puts response.code	
end

puts "All files uploaded!.."
