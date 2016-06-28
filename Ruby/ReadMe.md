# Sergio S.  
#### sergiognrl@hotmail.com  
#### http://RunTechServices.com  

-------------------------  

### Ruby

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

**stackexchangeapi_helper.rb**  
*Custom Ruby script for Stackoverflow.com querying of user's account*

* displays stackexchange.com user's quetions/relevant-information
* information displayed in Rails partial throughout online portfolio  

> Quick View  
> https://bitbucket.org/wowiamhere/codesamples/src/24be17bf262b84c399c9543f9fdda337521b38db/Ruby/stackexchangeapi_helper.rb?at=master  

> Link to script within project  
> https://bitbucket.org/wowiamhere/runtechservices/src/42dd618a9112a1eb45f1365f054461de81a362bc/app/helpers/stackexchangeapi_helper.rb?at=master  

------------------------