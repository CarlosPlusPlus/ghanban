class BoardsController < ApplicationController
  before_action :authenticate_user!

  def new
    @user  = current_user
    @repos = octokit.repos.collect(&:full_name)
  end

  def create
    puts 'Hello World!'
  end
end
