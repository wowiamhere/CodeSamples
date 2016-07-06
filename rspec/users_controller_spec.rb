require 'rails_helper'

RSpec.describe UsersController, type: :controller do 

		# Makind sure subjec is correct controller
	it "subject:should be Users Controller" do 
		expect(subject).to be_an_instance_of UsersController
	end

#---------------------------------index tests
	describe "GET index" do 

		context "before_action:" do 

			it "redirects to root if not logged" do 
				get :index
				expect(response).to redirect_to root_url
			end

		end # context not logged/in/no user

		context "after before_action:" do 

			it "renders all users(index)if logged in and admin" do 
				controller.stub(:is_admin)
				get :index
				expect(response).to render_template :index
			end

			it "before_filter skipped;assigns variables;200 response status;renders :index" do 
				@user1 = @user = User.create(id: "1", name:"one", email:"one@one.one", password:"password", password_confirmation:"password", admin:true)
				@user2 = @user = User.create(id: "2", name:"two", email:"two@two.two", password:"password", password_confirmation:"password", admin:false)

				subject.class.skip_before_filter :is_admin

				get :index
				expect(assigns(:users).size).to eq 2
				expect(response.status).to eq 200
				expect(response).to render_template :index
			end

		end #context: "logged in user"

	end # describe: "GET index"

#---------------------------------show tests
	describe "GET show" do 

		context "not logged in/wrong user" do 
			
			it "redirects to login if not logged in" do 
				get :show, id: "1"
				expect(response).to redirect_to login_url
				expect(response.body).not_to be nil
			end

		end #context: not logged in/wront user

		context "bypassing before filters;rendering show;setting variables" do 

			before(:example) do 
				@user = User.create id: "1", name:"one", email:"one@one.one", password:"password", password_confirmation:"password", userimage: "user_1.jpg"
			end

			it "renders show template;sets user for show;sets pic for S3" do 
				subject.class.skip_before_filter :is_logged_in
				subject.class.skip_before_filter :is_user

				get :show, id:"1"
				expect(response.status).to be 200
				expect(assigns(:user)).to be_an_instance_of User
				expect(assigns(:pic)).to match /user_[\d]{1,}\.[\D]{1,4}/
				expect(response).to render_template :show
			end

		end # context: loggedin user:renders show

	end #describe: GET show
#---------------------------------POST create tests
	describe "POST create" do 

		it "check: save user;set flash msg;kid of user;response status" do
			post :create, {user: { name:"one", email:"three@one.one", password:"password", password_confirmation:"password" }}
			expect(assigns(:user).save!).to be true
			expect(flash[:success]).to match /Your RunTech Account has been created!/
			expect(assigns(:user)).to be_an_instance_of User
			expect(response).to redirect_to assigns(:user)
		end

	end #describe: Post create

#---------------------------------PUT update tests	
	describe "PUT uddate test::" do 

			before(:example) do 
				@user = User.create id: "1", name:"one", email:"one@one.one", password:"password", password_confirmation:"password", userimage: "user_1.jpg"

				subject.class.skip_before_filter :is_logged_in
				subject.class.skip_before_filter :is_user			
			end

				# Checks: @users set;set flash;redirection to @user profile.
			it "with all correct information, no image" do 
				put :update, id: @user.id, user: { name: "new Name", email: @user.email, password:@user.password, password_confirmation: @user.password_confirmation }

				expect(assigns(:user)).to be_an_instance_of User
				expect(response).to redirect_to @user
				expect(controller.action_name).to match /update/
			end

				# Checks: clears controller (status 200);error upon save;render :edit
			it "with incorrect information" do 
				put :update, id: @user.id, user: { name: "one" }

				expect(response.status).to be 200
				expect{ assigns(:user).save! }.to raise_error ActiveRecord::RecordInvalid
				expect(response).to render_template :edit
			end

	end #describe: PUT update

#---------------------------------DELETE destroy tests
	describe "DELETE destroy test" do
		
		context "submit user with info:" do

			before(:example) do 
				@user = User.create id: "1", name:"one", email:"one@one.one", password:"password", password_confirmation:"password", userimage: "user_1.jpg"
				subject.class.skip_before_filter :is_logged_in
				subject.class.skip_before_filter :is_user	
				controller.stub(:logout)
			end

			it "deletes account and redirects to sign-up page" do 
				delete :destroy, id: "1"
				expect(response).to redirect_to new_user_path
				expect(flash[:notice]).to match /User was successfully destroyed./
			end

		end	#context "submit user with info:"
	end #describe: "DELETE destroy test"


end