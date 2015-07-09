class SessionsController < ApplicationController
  def new
    render layout: "guest_pages/guest_layout"
  end

  def create
    @user = User.find_by_email params[:email]

    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id

      flash[:success] = "Welcome, #{@user.first_name}"
      redirect_to user_path(@user)
    else
      flash[:danger] = "Username and/or Password dont appear to be correct"
      redirect_to signin_path
    end
  end

  def destroy
    if session[:id]
      session[:id] = nil
      flash[:success] = "Bye Bye. Have fun storming the castle."
    else
      flash[:danger] = "Errr, you can't log out when you aren't logged in. That's science."
    end

    redirect_to signin_path
  end
end
