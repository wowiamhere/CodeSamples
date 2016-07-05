# Sergio S.  
#### sergioGnrl@hotmail    
#### RunTechServices.com  
 
-------------------------  

### AngularJs  

**angularSample.js**  
*This is a set of custom AngularJs controllers/factories/services from [Latest Fashion Trendz](https://bitbucket.org/wowiamhere/latestfashiontrendzblog) bitbucket accout*

AngularJs uses rails backend custom controller `(~/app/controllers/api/)` to serve postgresql data to frontend user

- Factory to set request methods, data source url and tie it to user's id.
- app.js Injects necessary services (ngRoute, ngResource, etc)
- AngularJs index controller to display all data in table
- AngularJs Edit controller to edit database from frontend  

> [Quick View](https://bitbucket.org/wowiamhere/codesamples/src/24be17bf262b84c399c9543f9fdda337521b38db/AngularJs/angularSample.js?at=master, "wowiamhere's bitbucket account")  

> [Link to scripts within project](https://bitbucket.org/wowiamhere/latestfashiontrendzblog/src/d03d0fd419eea68e6b58cea368129e3a6b230659/app/assets/javascripts/?at=master, "wowiamhere's bitbucket account")  

-------------------------

### Postgresql  
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

> [Link to scripts](https://bitbucket.org/wowiamhere/codesamples/src/24be17bf262b84c399c9543f9fdda337521b38db/PostgreSql/?at=master, "wowiamhere's bitbucket account")  

------------------------  

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

### RSpec  

*These are a collection of Model tests for my Rails Online Portfolio*  

##### Model specs  

**user_spec.rb** 

- Takes User Model from my Online Portfolio and tests for Validation  
	which is implemented via Rails:  
	- presence  
	- length (depends on Model attributes)  
	- format (email -regex)  

> [Quick View](https://bitbucket.org/wowiamhere/codesamples/src/a3fc1eb1103919f4698178da9e5d4dab458df29c/rspec/user_spec.rb?at=master, "wowiamhere's bitbucket account")  

> [Link to script withi project](https://bitbucket.org/wowiamhere/runtechservices/src/aa60bb9479aa7f4f54c9347fb3deff827b778401/spec/models/user_spec.rb?at=master, "wowiamhere's bitbucket account")  

**post_spec.rb & comment_spec.rb**  

- Takes Comment/Post Model for testing implemented via Rails  
	- presence, length  

> [Quick View (post_spec)](https://bitbucket.org/wowiamhere/codesamples/src/a3fc1eb1103919f4698178da9e5d4dab458df29c/rspec/post_spec.rb?at=master, "wowiamhere's bitbucket account") / [(comment_spec)](https://bitbucket.org/wowiamhere/codesamples/src/a3fc1eb1103919f4698178da9e5d4dab458df29c/rspec/comment_spec.rb?at=master, "wowiamhere's bitbucket account")  

> [Link to script within project (post_spec)](https://bitbucket.org/wowiamhere/runtechservices/src/aa60bb9479aa7f4f54c9347fb3deff827b778401/spec/models/post_spec.rb?at=master, "wowiamhere's bitbucket account") / [(comment_spec)](https://bitbucket.org/wowiamhere/runtechservices/src/aa60bb9479aa7f4f54c9347fb3deff827b778401/spec/models/comment_spec.rb?at=master, "wowiamhere's bitbucket account")    

##### Controller specs  

**users_controller_spec.rb**  

- UsersController#index (displays all data on table if user logged in && adin -skip before filter)  
	- checks  
		- redirect to root_url if not logged in  
		- @users Enumerable is set  
		- response status  
		- renders :index template   
- UsersController#show (shows 1 item in table if logged in && user == current_user -skip before filter)  
	- checks  
		- redirect to login if not logged in  
		- response status  
		- variables set (@user, @pic) (via rspec match)  
		- renders :show template  

> [Quick View](https://bitbucket.org/wowiamhere/codesamples/src/f6e51502b4d4fd2d51c974ff25949eb0550038c4/rspec/users_controller_spec.rb?at=master, "wowiamhere's bitbucket account")  

> [Link to script within project]()  

------------------------

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

> [Quick View](https://bitbucket.org/wowiamhere/codesamples/src/24be17bf262b84c399c9543f9fdda337521b38db/Ruby/stackexchangeapi_helper.rb?at=master, "wowiamhere's bitbucket account")  

> [Link to script within project](https://bitbucket.org/wowiamhere/runtechservices/src/42dd618a9112a1eb45f1365f054461de81a362bc/app/helpers/stackexchangeapi_helper.rb?at=master, "wowiamhere's bitbucket account")  

------------------------


