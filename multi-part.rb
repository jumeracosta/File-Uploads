require 'uri'
require 'net/http'
require 'yaml'


user = YAML.load_file(File.dirname(__FILE__) + "/users_example.yml")
auth = user[1]["auth_token"]

url = URI("http://localhost:3000/projects/8/attachments.json?auth_token=#{auth}")

http = Net::HTTP.new(url.host, url.port)

request = Net::HTTP::Post.new(url)
request["content-type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
request["cache-control"] = 'no-cache'
request["postman-token"] = '269a4916-cd17-e910-1342-ef2bb9e085a3'
request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"attachment[attachment]\"; filename=\"/files/test_pdf.pdf\"\r\nContent-Type: image/jpeg\r\n\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"

response = http.request(request)
puts response.read_body
puts response.code

# Typhoeus.post(
#   "http://localhost:3000/posts",
#   body: {
#     title: "test post",
#     content: "this is my test",
#     file: File.open("thesis.txt","r")
#   }
# )
