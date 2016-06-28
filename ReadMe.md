# sergiognrl@hotmail.com

http://RunTechServices.com

#### AngularJs

**angularSample.js**  
*This is a set of custom AngularJs controllers/factories/services from [Latest Fashion Trendz](https://bitbucket.org/wowiamhere/latestfashiontrendzblog) bitbucket accout*

AngularJs uses rails backend custom controller `(~/app/controllers/api/)` to serve postgresql data to frontend user

- Factory to set request methods, data source url and tie it to user's id.
- app.js Injects necessary services (ngRoute, ngResource, etc)
- AngularJs index controller to display all data in table
- AngularJs Edit controller to edit database from frontend

-------------------------

#### Postgresql

**PostgreSqlQuery.rb**
*Query local PostgreSQL database deployment*

- table_rows_types
	- Selects column name and data type.
- table_info
	- Selects all table data from local deployment from controller for displaying in views
- get_table_names (based on shema)
	- fetches tables within specified Postgre schema

**database.rb**
*Query local postgreSql database deployment*

- tables
	- default schema to look under: public
	- fetches all tables within specified schema (called from Rails controller)

- get_schemas
	- App exposes a UI to user to pick schema to look under

------------------------

#### Rails/Ruby

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

**S3Controller.rb**
*Controller where custom S3 Ruby uploader called.*

* Controller takes file from user
- Passes file to delete_picture_put_new_one where ruby uuploader takes over
	* delete_picture_put_new_one
	+ Checks for file name in users table (postres)
	- Deletes current picture in S3
	* Updates name of new picture to users table (postres)
	+ Calls custom uploader to Put picture on S3 

------------------------

#### Ruby

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

------------------------


