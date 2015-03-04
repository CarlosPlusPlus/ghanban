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
    @board = Board.new(name: params[:board][:name])
    @board.users << current_user

    @client.auto_paginate = true # Access to ALL issues.

    params['board']['repos'].collect do |name|
      new_repo = Repo.where(name: name).length == 0
      repo = Repo.where(name: name).first_or_create
      repo.add_issues(@client.issues(name, state: 'all')) if new_repo
      @board.repos << repo
    end

    @board.save
    render action: 'show'
  end
end
