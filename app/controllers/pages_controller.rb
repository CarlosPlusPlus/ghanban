class PagesController < ApplicationController
  def index
    @repos = ["test1", "test2"]
  end
end
