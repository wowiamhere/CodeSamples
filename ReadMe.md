# sergiognrl@hotmail.com

http://RunTechServices.com

#### Ruby/Rails

*Custom made Ruby S3 uploader.*

* Takes picture over from controller (after resizing via Rmagick).
- Builds S3
- authorization, headers, signature, etc. (S3 specs).
	- http://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html
	+ http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-auth-using-authorization-header.html
- GETs an image via Net::HTTP::Get
- PUTs an image via Net::HTTP::Put
- DELETES an image via Net::HTTP::Delete

------------------------

#### Rails

*Controller where custom S3 Ruby uploader called.*

* Controller takes file from user
- Passes file to delete_picture_put_new_one where ruby uuploader takes over
	* delete_picture_put_new_one
	+ Checks for file name in users table (postres)
	- Deletes current picture in S3
	* Updates name of new picture to users table (postres)
	+ Calls custom uploader to Put picture on S3 

------------------------

#### Postgresql

*Query local PostgreSQL database deployment*

- Selects column name and data type.
- Selects table from local deployment database 
	and displays data

------------------------

#### Angular

*This is a set of custom AngularJs controllers/factories/services from [Latest Fashion Trendz](https://bitbucket.org/wowiamhere/latestfashiontrendzblog) bitbucket accout*

AngularJs uses rails backend custom controller `(~/app/controllers/api/)` to serve postgresql data to frontend user


### AngularJs.js
- Factory to set request methods, data source url and tie it to user's id.
- app.js Injects necessary services (ngRoute, ngResource, etc)
- AngularJs index controller to display all data in table
- AngularJs Edit controller to edit database from frontend