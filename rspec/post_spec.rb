require 'rails_helper'

RSpec.describe Post, type: :model do 

	before(:context) do 
		@post = Post.new title: "title", 
		subtitle: "subtitle", 
		category: "category", 
		subcategory: "subcat", 
		description: "1234 1234 1234 1234 1234 1234 1234 1234 ", 
		keywords: "keywords", 
		body: "a" * 200
	end

	it "checks if testing the right model" do 
		expect(subject).to be_an_instance_of Post
	end

	context "Validation" do 
		
# All fields are valid ------------------------------------------
		it "should pass with all fields included" do 
			expect(@post.valid?).to be true
		end

# Checking title------------------------------------------
		context "Validation: Title" do 
			it "should not pass with title empty" do
				@post.title = ""
				expect(@post.valid?).to be false
			end

			it "title cant be less than 3 characters" do 
				@post.title = "ab"
				expect(@post.valid?).to be false
			end

			it "title has to be at least 3 characters" do 
				@post.title = "abc"
				expect(@post.valid?).to be true
			end
		end #context: "Title Validation"

# Subtitle,category,subcategory----------------------------------
		context "Validation: subtitle,category,subcategory" do

			it "subtitle can't be empty" do 
				@post.subtitle = ""
				expect(@post.valid?).to be false
			end

			it "subtitle: less than 3 characters" do 
				@post.subtitle = "ab"
				expect(@post.valid?).to be false
			end

			it "subtitle: atleast 3 characters" do 
				@post.subtitle = "abc"
				expect(@post.valid?).to be true
			end
# -----------
			it "category can't be empty" do 
				@post.category = ""
				expect(@post.valid?).to be false
			end

			it "category: less than 3 characters" do 
				@post.category = "ab"
				expect(@post.valid?).to be false
			end

			it "category: atleast 3 characters" do 
				@post.category = "abc"
				expect(@post.valid?).to be true
			end
# -----------			
			it "subcategory can't be empty" do 
				@post.subcategory = ""
				expect(@post.valid?).to be false
			end

			it "subcategory: less than 3 characters" do 
				@post.subcategory = "ab"
				expect(@post.valid?).to be false
			end

			it "subcategory: atleast 3 characters" do 
				@post.subcategory = "abc"
				expect(@post.valid?).to be true
			end			

		end #"Validation: subtitle,category,subcategory"

# Validation: Description and body-----------------
		context "Validation: description, body" do 

			it "description: should be present" do 
				@post.description = ""
				expect(@post.valid?).to be false
			end

			it "description: less than 40 characters" do 
				@post.description = "1234 "
				expect(@post.valid?).to be false
			end

			it "description: at least 40 characters" do 
				@post.description = "1234 1234 1234 1234 1234 1234 1234 1234 "
				expect(@post.valid?).to be true
			end
#--------------
			it "body: should be present" do 
				@post.body = ""
				expect(@post.valid?).to be false
			end
			
			it "body: less than 200 characters" do 
				@post.body = "1234 "
				expect(@post.valid?).to be false
			end

			it "body: at least 200 characters" do 
				@post.body = "a" * 200
				expect(@post.valid?).to be true
			end

		end # context: "Validation: description, body"

	end

end
