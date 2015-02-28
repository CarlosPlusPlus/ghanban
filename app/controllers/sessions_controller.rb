class SessionsController < ApplicationController
  def new
    redirect_to '/auth/github'
  end

  def create
    auth   = request.env['omniauth.auth']
    user   = User.where(uid: auth['uid'].to_s).first || User.create_with_omniauth(auth)
    reset_session
    session[:user_id]      = user.id
    session[:access_token] = auth['credentials']['token']

    redirect_to user_path(user.id), notice: 'Signed in!'
  end

  def destroy
    reset_session
    redirect_to root_url, notice: 'Signed out!'
  end

  def failure
    redirect_to root_url, alert: "Authentication Error: #{params[:message].humanize}"
  end
end
