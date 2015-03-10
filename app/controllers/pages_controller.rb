class PagesController < ApplicationController
  def index
    @boards = current_user.try(:boards)
  end
end
