module StackexchangeapiHelper

# class for stackoverflow api information for making reqs
	class StackInfoCall 

		URL = "http://api.stackexchange.com/2.2"
		USER = "users"
		QUESTION = "questions"
		QUERRYSTR = "order=desc&site=stackoverflow"
		USER_ID = "2218325"

	end

	class StackExchangeApi
		attr_accessor :api_url, :api_get_user, :api_question, :api_qstr, :api_user_id

		def overflowCall
		# preparing the url 
			url = URI.parse("#{StackInfoCall::URL}/#{StackInfoCall::USER}/#{StackInfoCall::USER_ID}/#{StackInfoCall::QUESTION}?#{StackInfoCall::QUERRYSTR}")

		# preparing request
			req = Net::HTTP::Get.new(url.to_s)

				# making call
			resp = Net::HTTP.start(url.host, url.port) do |http|
				http.request(req)		
			end
		# parsing body to JSON
			json_resp = JSON.parse(resp.body)

		# json to store all info needed
			info_hash = JSON.generate({})

		# parsing to json
			info_hash = JSON.parse(info_hash)

		# getting user info 
			info_hash[:stackoverflow_user] = {
				:username => json_resp["items"][0]["owner"]["display_name"],
				:profile 	=> json_resp["items"][0]["owner"]["link"],
				:number_of_questions => json_resp["items"].count
			}

		# looping through response to gather item desired 
			json_resp["items"].each do |item|

			# -storing information in hash (on a per question basis)
			#   each question is the name of the index
			# -hash to be used in instance variable in home controller to display in views

				info_hash["#{item["title"]}"]	= {
					:tags 				=> item["tags"], 
					:user 				=> item["owner"]["display_name"],
					:user_link 		=> item["owner"]["link"],
					:answered 		=> item["is_answered"],
					:view_count		=> item["view_count"],
					:answer_id 		=> item["accepted_answer_id"],
					:link_to_q		=> item["link"]
				}
			end

			# returning info_hash to controller for views
			info_hash

		end
		
	end
end