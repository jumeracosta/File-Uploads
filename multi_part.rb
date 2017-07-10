
require 'uri'
require 'net/http'
require 'yaml'
require 'openssl'

files = Dir.glob('*/*').select {|f| File.file? f}
puts "Processing all.. "

$i = 1
$no_execute = 2 #update to how many times it will execute

while $i <= $no_execute do
	files.each do |fname| #iterate over each file
	 	file = File.open(fname)
		byte_representation = file.read
		#for authentication
		user = YAML.load_file(File.dirname(__FILE__) + "/users_example.yml") 
		auth = user[2]["auth_token"]
		#url = URI("http://localhost:3000/projects/8/attachments.json?auth_token=#{auth}")
		url = URI("https://test.kona.com/projects/8/attachments.json?auth_token=#{auth}")

		http = Net::HTTP.new(url.host, url.port)

		#check if https request
		if url.instance_of? URI::HTTPS
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		end

		#POST request to upload all files in a directory
		request = Net::HTTP::Post.new(url)
		request["content-type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
		request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"attachment[attachment]\"; filename=\"#{fname}\"\r\nContent-Type: image/jpeg\r\n\r\n#{byte_representation}\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
				
		response = http.request(request)
		split_name = fname.split("/")[-1]
		puts "#{split_name}..." + response.code
	end
$i += 1
end
	#puts "All files uploaded!.."