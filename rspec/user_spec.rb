require 'rails_helper'

RSpec.describe User, type: :model do

	before(:context) do 
		@user = User.new name: "one", email: "one@one.one", password: "password", password_confirmation: "password"
	end

		# Check if testing correct model
	it "is this the correct model?" do 
		expect(subject).to be_an_instance_of User
	end

		# For validation of MODEL
		# Data passed by user via front-end forms
		# 	displayed via ~/app/views (name, email, password, password_confirmation)
	context "validation" do 	

		it "saves to database with all correct data" do 
			expect(@user.valid?).to be true
		end

		it "doesn't save if name missing" do
			@user.name = "" 
			expect(@user.valid?).to be false
		end

		it "doesn't save if email missing" do 
			@user.email = ""
			expect(@user.valid?).to be false
		end

		it "doesn't save if password missing" do 
			@user.password = ""
			@user.password_confirmation = ""
			expect(@user.valid?).to be false
		end

		it "doesn't save if password_confirmation is missing" do
			@user.password_confirmation = ""
			expect(@user.valid?).to be false
		end 

		it "doesn't save if password and confirmation differ" do 
			@user.password_confirmation = "password2"
			expect(@user.valid?).to be false
		end

		it "doesn't save if email is invalid" do 
			@user.email = "one.-#@thre .com"
			expect(@user.valid?).to be false
		end

	end # context: "validation"

end
