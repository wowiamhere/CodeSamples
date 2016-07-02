require 'rails_helper'

RSpec.describe Comment, type: :model do 

	before(:context) do 
		@comment = Comment.new(content: "Test:Assosiation Comment Content", user_id: "1", post_id: "1")
	end

	it "Testing the right model?" do 
		expect(subject).to be_an_instance_of Comment
	end

	context "Association: Comments" do 

		it "creates a valid comment via current user" do				
			expect(@comment.valid?).to be true
		end

		it "does not create a comment without user_id field" do 
			@comment.user_id = ""
			expect(@comment.valid?).to be false
		end

		it "does not create a comment without post_id field" do 
			@comment.post_id = ""
			expect(@comment.valid?).to be false
		end			

		it "does not create a comment without content field" do 
			@comment.content = "ab c"
			expect(@comment.valid?).to be false
		end

	end

end