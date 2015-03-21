class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, except: [:index]

  def show
    @user   = current_user || User.find(params[:id])
    @boards = current_user.boards
  end
end
