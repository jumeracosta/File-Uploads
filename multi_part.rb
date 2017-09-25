
require 'uri'
require 'net/http'
require 'yaml'
require 'openssl'

#for authentication
user = YAML.load_file(File.dirname(__FILE__) + "/users_example.yml")
auth = user[2]["auth_token"]
#url = URI("http://localhost:3000/projects/8/attachments.json?auth_token=#{auth}")
url = URI("https://alpha.kona.com/projects/137822/attachments.json?auth_token=#{auth}")

files = Dir.glob('*/*').select {|f| File.file? f}
puts "Processing all.. "

execute = YAML.load_file(File.dirname(__FILE__) + "/no_execute.yml")
$i = 1
$no_execute = execute[1] #given times it will execute

while $i <= $no_execute do
	files.each do |fname| #iterate over each file
	 	file = File.open(fname)
		byte_representation = file.read

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