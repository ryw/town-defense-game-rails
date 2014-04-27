# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController

  def new
    @active_heros = Hero.top_active_heros if Hero.top_active_heros.size > 0
    @dead_heros = Hero.top_dead_heros if Hero.top_active_heros.size > 0
  end

  def create
    puts params
    password_authentication(params[:login], params[:password])
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  protected

  def password_authentication(login, password)
    self.current_user = User.authenticate(login, password)
    if logged_in?
      successful_login
    else
      failed_login
    end
  end

  def successful_login
    if params[:remember_me] == "1"
      self.current_user.remember_me
      cookies[:auth_token] = {
        :value => self.current_user.remember_token,
        :expires => self.current_user.remember_token_expires_at }
    end
    redirect_to games_url
    flash[:notice] = "Logged in successfully"
  end

  def failed_login
    redirect_to login_url
    flash.now[:error] = "Invalid login"
  end
end
