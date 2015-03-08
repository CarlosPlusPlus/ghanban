class PagesController < ApplicationController
  def index
    @user = current_user
    @boards = current_user.boards
  end
end
