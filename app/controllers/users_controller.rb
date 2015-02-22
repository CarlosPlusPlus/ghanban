class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user?, :except => [:index]

  def index
    @boards = current_user.boards
    @repos  = octokit.repos.collect(&:full_name)
  end

  def show
    @user = User.find(params[:id])
  end
end
