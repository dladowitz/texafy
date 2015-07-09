module ControllerSpecHelpers
  def login_user(user)
    session[:id] = user.id
  end

  def logout_current_user
    session[:id] = nil
  end
end
