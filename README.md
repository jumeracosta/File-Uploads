## Install and Preparation

``` 
  run `bundle install`
```

The script will upload all files in a >/files directory. Recently, I've added 4 different file types(.docx, .txt, .pdf and .jpg) that will be uploaded to Kona Team space by default.

You can update the `no_execute` data in >/initial_data folder for how many times you may wish to execute your file upload request. 

#To upload new file:
  - put your new files in >/files folder
  - and then run `ruby multi_part.rb`
Then on terminal logs it will display the files being uploaded with status(200 for success!)

