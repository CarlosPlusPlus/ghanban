class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, :except => [:index]

  def index
  end

  def show
    @user   = current_user || User.find(params[:id])
    @boards = current_user.boards
    @repos  = octokit.repos.collect(&:full_name)
  end
end
