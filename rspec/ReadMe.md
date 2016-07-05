# Sergio S.  
#### sergioGnrl@hotmail    
#### RunTechServices.com  
 
-------------------------  

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

------------------------

##### Controller specs  

**users_controller_spec.rb**  

- UsersController#index (displays all data on table if user logged in && adin -skip before filter)  
	- checks  
		- redirect to root_url if not logged in  
		- users Enumerable is set  
		- response status  
		- renders :index template   
- UsersController#show (shows 1 item in table if logged in && user == current_user -skip before filter)  
	- checks  
		- redirect to login if not logged in  
		- response status  
		- variables set (user, pic) (via rspec match)  
		- renders :show template  

> [Quick View](https://bitbucket.org/wowiamhere/codesamples/src/f6e51502b4d4fd2d51c974ff25949eb0550038c4/rspec/users_controller_spec.rb?at=master, "wowiamhere's bitbucket account")  

------------------------