class BoardsController < ApplicationController
  before_action :authenticate_user!
  before_action :octokit, only: :create

  def new
    @user  = current_user
    @repos = octokit.repos.collect(&:full_name)
  end

  def show
  end

  def create
    @board = Board.new(name: params[:name])
    @board.users << current_user

    @client.auto_paginate = true # Access to ALL issues.

    params['board']['repos'].collect do |name|
      repo = Repo.find_or_initialize_by(name: name)
      repo.add_issues(@client.issues(name, state: 'all')) if repo.new_record?
      @board.repos << repo
    end

    @board.save
    render action: 'show'
  end
end
