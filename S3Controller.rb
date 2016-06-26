=begin 

  
  Controller where custom S3 Ruby uploader called
    - Controller takes file from user
    - Passes file to delete_picture_put_new_one where
        ruby uuploader takes over
    - delete_picture_put_new_one
      - Checks for file name in users table (postres)
      - Deletes current picture in S3
      - Updates name of new picture to users table (postres)
      - Calls custom uploader to Put picture on S3 
=end


class UsersController < ApplicationController
  before_action :is_logged_in, only: [:show, :edit, :update, :destroy]
  before_action :is_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :is_admin, only: [:index]

  # PATCH/PUT /users/1
    # PATCH/PUT /users/1.json
  def update
    respond_to do |format|

        # If there is an image uploaded proceed to 
        #   - delete current picture in S3
        #   - delete picture imgage entry in users table 
        #   - update S3 and userimage in database
        # Method in privates (below)
      unless params[:user][:userimage].nil?
        delete_picture_put_new_one params[:user][:userimage].tempfile
      end

      if @user.update(user_params)
        format.html { redirect_to @user } #, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
       @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end

    def update_params
      params.require(:user).permit(:name, :email, :admin)
    end


    def delete_picture_put_new_one pic_file
       # Passing the image uploaded to ~/app/helpers/home_helper#pictureHandler
        #   to be resized, renamed and ready to be sent to S3 via custom api at 
        #   ~/app/helpers/S3ApiHelper 
      image_to_upload_to_s3 = pictureHandler pic_file

        # Image name to be ammended to 'user_' as image name on s3
      user_id_image = @user.id

        # If user has image, 
      unless @user.userimage.nil?
        S3ApiDelete @user.userimage          
      end
      
        # Updating image name in pg users table
      image_name_for_database = "user_#{user_id_image}#{File.extname image_to_upload_to_s3}"
      @user.update userimage: image_name_for_database

        # Instantiating and calling S3Api from 
        #   ~app/helpers/seapi_helper.rb::s3Api#S3ApiPut(img, id)
      S3ApiPut image_to_upload_to_s3, user_id_image
    end

end
