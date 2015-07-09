class PasswordResetsController < ApplicationController
  layout "guest_pages/guest_layout"
  
  def request_password
    @password_reset = PasswordReset.new
  end

  def create
    @user = User.find_by_email params[:email]

    if @user
      password_reset = @user.password_resets.create
      token = password_reset.token

      #TODO Mailer should be sent asyncronously. Need to change so not to hold up the controller
      UserMailer.request_password(@user, token).deliver

      render  :email_sent
    else
      flash.now[:danger] = "Email address not found."
      render :request_password
    end
  end

  def reset_password
    @password_reset = PasswordReset.find_by_token params[:token]
    if @password_reset
      @user = @password_reset.user

      if @password_reset.used?
        render :already_used and return
      end
    else
      flash.now[:danger] = "Invalid password request link. Maybe request a new password reset link."
      render :request_password and return
    end
  end

  def update
    @password_reset = PasswordReset.find_by_token params[:token]

    if @password_reset
      @user = @password_reset.user
      @user.update_attributes user_params

      if @user.save
        flash[:success] = "Password updated. Try it out by signing in."
        @password_reset.update used: Time.now
        redirect_to signin_path
      else
        render :reset_password
      end
    else
      flash[:danger] = "Invalid link."
      render :request_password
    end
  end


  private

  # would be cool if we could just call the user_params method on the users_controller
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
