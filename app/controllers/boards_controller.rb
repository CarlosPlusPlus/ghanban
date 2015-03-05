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
      repo = Repo.where(name: name).first_or_create { @new_repo = true }

      if @new_repo
        repo.add_repo_labels(@client.labels(name))
        repo.add_issues(@client.issues(name, state: 'all'))
        @new_repo = false
      end

      @board.repos << repo
    end

    @board.save
    render action: 'show'
  end
end
