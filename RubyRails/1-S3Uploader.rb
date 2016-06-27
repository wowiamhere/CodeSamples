=begin 

	Custom made Ruby S3 uploader.
		- Takes picture over from controller (after resizing via Rmagick).
		- Builds S3
				-authorization, headers, signature, etc. (S3 specs).
				http://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html
				http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-auth-using-authorization-header.html
		- GETs an image via Net::HTTP::Get
		- PUTs an image via Net::HTTP::Put
		- DELETES an image via Net::HTTP::Delete
=end


module S3Helper
	require 'date'
	require 'time'
	require 'base64'
	require 'openssl'
	require 'net/http'


	class S3CallInfo
			# holds all information necessary to construct http
		VERB = { get: "GET", put: "PUT", post: "POST", delete: "DELETE" }
		BUCKETS = { imgs: "" }
		ENDPOINTS = { AMAZONS3: "s3.amazonaws.com" }
		ACCESSKEYID = ""
		SECRETACCESSKEY = ""
		REGION = "us-west-2"
		SERVICE = "s3"
		PATH = "portfoliopics/thumbs/"
		S3CONSTANT = "aws4_request"
		BODY_DELIMIT = "xA++==++**Ax"
		S3_PICTURE_PATH = "http://s3-us-west-2.amazonaws.com/runtechimages/portfoliopics/thumbs/"

			#	Date iso8601 for x-amz-date header and string to sign timestamp.
			# Date for request.
		  # Date for <scope> and <signing key> ( s3 specs ).				
		FOR_TIME = Time.now.utc
		TIME8601 = FOR_TIME.strftime '%Y%m%dT%H%M%SZ'
		DATE_FOR_REQ = FOR_TIME.strftime "%a, %d %b %Y %T"
   	DATE_YMD_FORMAT = FOR_TIME.strftime "%Y%m%d" 

	end

		def S3ApiGet img

				# Image to retrieve from S3.
				# Uri and canonical uri for canonical request.
			file_name = "portfoliopics/thumbs/#{img.downcase}"
			uri = URI.parse "http://#{S3CallInfo::BUCKETS[:imgs]}.#{S3CallInfo::ENDPOINTS[:AMAZONS3]}/#{file_name}"
			canonical_uri = uri.request_uri

				
				# Ruby's Get request.
			get_req = Net::HTTP::Get.new uri.request_uri


				# getHeaders (private) gets the uri and request object.
				# It consolidates S3 required headers and ruby's object's native headers
				# Sorts headers, builds string of signed headers (s3 spec)
				# returns all the above along with a hex-sha256 of the payload
			headers_return = getHeaders uri, get_req
			headers = headers_return[0]
			get_req = headers_return[1]
			headers_string = headers_return[2]
			signed_headers = headers_return[3]
			payload_hex_hash = headers_return[4]

				# S3's canonical request, hexed-sha256 and string to use for the signature in Authentication header (s3 specs).
				# While S3 states an empty payload is to be a hex-sha256 of an empty string;this does not seem to be the case.
			canonical_request = "#{S3CallInfo::VERB[:get]}\n#{canonical_uri}\n\n#{headers_string}\n#{signed_headers}\nUNSIGNED-PAYLOAD"#{payload_hex_hash}"
		  canonical_req_hex = Digest::SHA256.hexdigest canonical_request 
			string_to_sign = "AWS4-HMAC-SHA256\n#{S3CallInfo::TIME8601}\n#{S3CallInfo::DATE_YMD_FORMAT}/#{S3CallInfo::REGION}/#{S3CallInfo::SERVICE}/aws4_request\n#{canonical_req_hex}"


				# S3GetSig takes the string to sign and returns an Hex-HMAC-SHA256 for the Autherization header
			signature = S3GetSig string_to_sign


				# Putting into Ruby's native Get object.
			headers["Authorization"] = "AWS4-HMAC-SHA256 Credential=#{S3CallInfo::ACCESSKEYID}/#{S3CallInfo::DATE_YMD_FORMAT}/#{S3CallInfo::REGION}/#{S3CallInfo::SERVICE}/aws4_request,SignedHeaders=#{signed_headers},Signature=#{signature}"
			get_req.[]= "Authorization", headers["Authorization"]


				# res.body has the picture ready for further processing.
			res = Net::HTTP.start( uri.hostname, uri.port ) do |http_connection|	
				http_connection.request get_req 
			end

			res

		end #S3ApiGet

		def S3ApiPut img, id 
		
				# Getting file name from img file parameter.
				# Uri to use for ruby's Net::HTTP request.
				# Building canonical uri to insert in request string.
			file_ext = File.extname img
			file_name = "#{ S3CallInfo::PATH }user_#{ id }#{ file_ext }"
			uri = URI.parse "http://#{S3CallInfo::BUCKETS[:imgs]}.#{S3CallInfo::ENDPOINTS[:AMAZONS3]}/#{file_name}"
			canonical_uri = uri.request_uri

				# Put request.
				# The headers from this ruby object will be added to the headers in the
				# 	signature process.
				# The custom (S3 required) headers will be added to this object also.
			put_req = Net::HTTP::Put.new canonical_uri 

				# put_body [] for all the components of the body of the request.
				# S3CallInfo::body_delimit to encase body of request.
				# Setting payload inside body of reqest.
			put_body = []

			# put_body << "--#{S3CallInfo::BODY_DELIMIT}rn"
			# put_body << "Content-Disposition:form-data; name='picture'; filename='#{file_name}'rn"
			# put_body << "Content-Type:image/jpeg rn"
			# put_body << "rn"
			put_body << File.open( img, "rb" ).read
			# put_body << "rn--#{S3CallInfo::BODY_DELIMIT}--rn"

			put_req.body = put_body.join
		
				# Get headers from helper function (above)
				# Returns: 
				# 	-headers
				# 	-updated Ruby Net::http object
				# 	-headers string for authentication header(s3 specs)
				# 	-signed headers for authentication header(s3 specs)
			headers_return = getHeaders(uri, put_req)
			headers = headers_return[0]
			put_req = headers_return[1]
			headers_string = headers_return[2]
			signed_headers = headers_return[3]
			payload_hex_hash = headers_return[4]


				# Building canonical request string.
				# Hexing the canonical_req_hash ( S3 specs ).
		    # String to sign for authentication by S3.
			canonical_request = "#{S3CallInfo::VERB[:put]}\n#{canonical_uri}\n\n#{headers_string}\n#{signed_headers}\n#{payload_hex_hash}"
		  canonical_req_hex = Digest::SHA256.hexdigest canonical_request 
			string_to_sign = "AWS4-HMAC-SHA256\n#{S3CallInfo::TIME8601}\n#{S3CallInfo::DATE_YMD_FORMAT}/#{S3CallInfo::REGION}/#{S3CallInfo::SERVICE}/aws4_request\n#{canonical_req_hex}"

				# Calculating signature for request.
			signature = S3GetSig string_to_sign

				# Adding auth header to list of headers.
				# Adding authorization header to ruby object.		
			headers["Authorization"] = "AWS4-HMAC-SHA256 Credential=#{S3CallInfo::ACCESSKEYID}/#{S3CallInfo::DATE_YMD_FORMAT}/#{S3CallInfo::REGION}/#{S3CallInfo::SERVICE}/aws4_request,SignedHeaders=#{signed_headers},Signature=#{signature}"
			put_req.[]= "Authorization", headers["Authorization"]							

				# Opening http connection in one block ( auto closes it at end of block )
				# 	returning the response.
			res = Net::HTTP.start( uri.hostname, uri.port ) do |http_connection|
				http_connection.request put_req 
			end		

			res
				
		end #S3ApiPut

		def S3ApiDelete img
				# Getting file name from img file parameter.
				# Uri to use for ruby's Net::HTTP request.
				# Building canonical uri to insert in request string.
			file_name= "portfoliopics/thumbs/#{img}"
			uri = URI.parse "http://#{S3CallInfo::BUCKETS[:imgs]}.#{S3CallInfo::ENDPOINTS[:AMAZONS3]}/#{file_name}"
			canonical_uri = uri.request_uri

				# Delete request.
				# The headers from this ruby object will be added to the headers in the
				# 	signature process.
				# The custom (S3 required) headers will be added to this object also.
			delete_req = Net::HTTP::Delete.new canonical_uri 

					# Get headers from helper function (above)
				# Returns: 
				# 	-headers
				# 	-updated Ruby Net::http object
				# 	-headers string for authentication header(s3 specs)
				# 	-signed headers for authentication header(s3 specs)
			headers_return = getHeaders(uri, delete_req)
			headers = headers_return[0]
			delete_req = headers_return[1]
			headers_string = headers_return[2]
			signed_headers = headers_return[3]
			payload_hex_hash = headers_return[4]

				# Building canonical request string.
				# Hexing the canonical_req_hash ( S3 specs ).
		    # String to sign for authentication by S3.
			canonical_request = "#{S3CallInfo::VERB[:delete]}\n#{canonical_uri}\n\n#{headers_string}\n#{signed_headers}\nUNSIGNED-PAYLOAD" #{payload_hex_hash}"
		  canonical_req_hex = Digest::SHA256.hexdigest canonical_request 
			string_to_sign = "AWS4-HMAC-SHA256\n#{S3CallInfo::TIME8601}\n#{S3CallInfo::DATE_YMD_FORMAT}/#{S3CallInfo::REGION}/#{S3CallInfo::SERVICE}/aws4_request\n#{canonical_req_hex}"

				# Calculating signature for request.
			signature = S3GetSig string_to_sign

				# Adding auth header to list of headers.
				# Adding authorization header to ruby object.		
			headers["Authorization"] = "AWS4-HMAC-SHA256 Credential=#{S3CallInfo::ACCESSKEYID}/#{S3CallInfo::DATE_YMD_FORMAT}/#{S3CallInfo::REGION}/#{S3CallInfo::SERVICE}/aws4_request,SignedHeaders=#{signed_headers},Signature=#{signature}"
			delete_req.[]= "Authorization", headers["Authorization"]							

				# Opening http connection in one block ( auto closes it at end of block )
				# 	returning the response.
			res = Net::HTTP.start( uri.hostname, uri.port ) do |http_connection|
				http_connection.request delete_req 
			end

			res

		end

private


		# Receives the Uri for the reauest and Ruby's request object.
		# Takes Ruby's native Get object's headers and merges them with S3 spec headers.
		# Sorts, and creates 2 strings: 1. signed headers, 2. headers (Pairs separated by colon) both S3 specs
		# Returns headers, request (with updated headers), and strings
	def getHeaders uri, req

		case req
			when Net::HTTP::Put then

					# Hash of payload to be used for signature.
				payload_hex_hash = Digest::SHA256.hexdigest req.body

				headers_temp = { 	
					"Date" => S3CallInfo::DATE_FOR_REQ,
					"host" => uri.host,
					"content-length" => req.body.size,
					#"content-type"	=> "multipart/form-data, boundary=#{S3CallInfo::BODY_DELIMIT}",
					"content-type" => "image/#{File.extname uri.path}",
					"x-amz-acl" => "public-read",
					"x-amz-content-sha256" => payload_hex_hash,
					"x-amz-date" => S3CallInfo::TIME8601,
					"x-amz-meta-cache-control" => "72000"
				}
			when Net::HTTP::Get then
			
					# If no payload, hexhas of empty string (s3 specs),
					# 	digest to be used as part of canonical request.
					# In contant-sha256 header a literal string if no payload present (s3 specs)
				payload_hex_hash = Digest::SHA256.hexdigest ""

				headers_temp = { 	
					 	"Date" => S3CallInfo::DATE_FOR_REQ,
						"host" => uri.host,
	#					"content-type" => "application/x-www-form-urlencoded",
						"x-amz-content-sha256" => "UNSIGNED-PAYLOAD",
						"x-amz-date" => S3CallInfo::TIME8601
					}
			when Net::HTTP::Delete then 
					
					# If no payload, hexhas of empty string (s3 specs),
					# 	digest to be used as part of canonical request.
					# In contant-sha256 header a literal string if no payload present (s3 specs)
				payload_hex_hash = Digest::SHA256.hexdigest ""

				headers_temp = { 	
					"Date" => S3CallInfo::DATE_FOR_REQ,
					"host" => uri.host,
					"x-amz-content-sha256" => "UNSIGNED-PAYLOAD",
					"x-amz-date" => S3CallInfo::TIME8601,
				}				
			end

				# Adding ruby's object's headers to headers to signature headers.
			headers_temp.each do |k,v|
				req.[]= k, v 
			end

				# Clearing to reload with all headers from Ruby object.
				# Preparing headers for transmission.
			headers_temp.clear
			req.each_header {|k,v|
				headers_temp[k] = v
			}

				# Need to sort hash of headers (S3 specs ).
				# Headers hash to be used for signature (s3).
				# Writing sorted headers to headers hash.		
			sorted_arr = headers_temp.keys.sort		
			headers = Hash.new
			sorted_arr.each do |val|
				headers[val] = headers_temp[val]
			end

				# String to concatenate all headers in hash.
				# String to concatenate all the header names included in signature.
			signed_headers = "" 
			headers_string = "" 

				# Looping through headers hash to bulid header string and signed header string ( s3 specs ).
				# Getting the headers into a single string:
				# 	all donwcased,
				# 	separated by newline.
				# Getting the header names in a string separated 
				# 	each by a colon ( except last ).			
			headers.each do |k,v| 
					headers_string += "#{k}:#{v}\n"				
				signed_headers += "#{k};"
			end

				# Cleaning last colon ( ; ) from signed_headers string ( s3 specifications ).
			signed_headers[( signed_headers.length ) - 1]  = ''				

				# Returnting end result:
				# 	headers, request with all headers, string of headers (signature), signed headers (signature).
			[ headers, req, headers_string, signed_headers, payload_hex_hash ]
	end

	def S3GetSig strToSign
				# Calculating signature for request.
				# Using digest, S3 credentials and date in headers.
			dig = 'sha256'
			signature_key = OpenSSL::HMAC.digest dig, "AWS4#{S3CallInfo::SECRETACCESSKEY}", S3CallInfo::DATE_YMD_FORMAT
			signature_key = OpenSSL::HMAC.digest dig, signature_key, S3CallInfo::REGION 
			signature_key = OpenSSL::HMAC.digest dig, signature_key, S3CallInfo::SERVICE 
			signature_key = OpenSSL::HMAC.digest dig, signature_key, S3CallInfo::S3CONSTANT 

				# Final signature for request.
	 	 	signature = OpenSSL::HMAC.hexdigest dig, signature_key, strToSign
	 	 	
	end
	# ---------end of private methods ---------------

end #module