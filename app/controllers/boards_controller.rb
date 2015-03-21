class BoardsController < ApplicationController
  before_action :authenticate_user!

  def new
    @user  = current_user
    @repos = get_repos.select { |repo| repo[:owner][:login] == current_user.username }.map(&:full_name)
  end

  def show
    @board   = Board.find_by_id(params[:id])
    @columns = [{name: 'Backlog'}, {name: 'Ready'}, {name: 'In Progress'}, {name: 'Done'}]
    @class   = 'kanban-page'
  end

  def create
    repos = params['board']['repos']

    @board = Board.new(name: params[:board][:name])
    @board.users << current_user

    # Create repos, add issues, and attach labels.
    add_board_labels(repos)
    repos.each { |repo_name| add_repo(repo_name) }

    @board.save
    render action: 'show'
  end

  private
    def add_board_labels(repos)
      labels = repos.map { |repo| get_labels(repo) }.flatten.group_by(&:name)
      labels.each { |name, value| @board.labels << Label.new(name: name, color: value[0][:color]) }
    end

    def add_repo(repo_name)
      repo = Repo.where(name: repo_name).first_or_create { @new_repo = true }
      initialize_new_repo(repo) if @new_repo
      @board.repos << repo
    end

    def initialize_new_repo(repo)
      repo.add_issues(get_issues(repo.name))
      add_webhooks(repo)
      @new_repo = false
    end
end
