# Sergio S.  
#### sergioGnrl@hotmail    
#### RunTechServices.com  
 
-------------------------  

### Rails/Ruby  

**S3Uploader.rb**  
*Custom Ruby Amazon's S3 PUT, GET, DELETE script*

* Takes picture over from a rails controller (after resizing via Rmagick).
- Builds S3:
	- authorization, headers, signature, etc. (S3 specs).
		- http://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html
		- http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-auth-using-authorization-header.html
- GETs an image from S3 via Net::HTTP::Get
- PUTs an image in S3 bucket via Net::HTTP::Put
- DELETES an image from S3 bucket via Net::HTTP::Delete  

> [Quick View](https://bitbucket.org/wowiamhere/codesamples/src/24be17bf262b84c399c9543f9fdda337521b38db/Ruby/S3Uploader.rb?at=master, "wowiamhere's bitbucket account")  

> [Link to script within project](https://bitbucket.org/wowiamhere/runtechservices/src/42dd618a9112a1eb45f1365f054461de81a362bc/app/helpers/s3_helper.rb?at=master, "wowiamhere's bitbucket account")  

**S3Controller.rb**  
*Controller where custom S3 Ruby uploader called.*

* Controller takes file from user
- Passes file to delete_picture_put_new_one where ruby uuploader takes over
	* delete_picture_put_new_one
	+ Checks for file name in users table (postres)
	- Deletes current picture in S3
	* Updates name of new picture to users table (postres)
	+ Calls custom uploader to Put picture on S3  

> [Quick View](https://bitbucket.org/wowiamhere/codesamples/src/24be17bf262b84c399c9543f9fdda337521b38db/RailsRuby/S3Controller.rb?at=master, "wowiamhere's bitbucket account")  

> [Link to script within project](https://bitbucket.org/wowiamhere/runtechservices/src/42dd618a9112a1eb45f1365f054461de81a362bc/app/controllers/users_controller.rb?at=master, "wowiamhere's bitbucket account")  

------------------------