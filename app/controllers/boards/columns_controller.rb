class Boards::ColumnsController < ApplicationController
  before_action :set_board
  before_action :set_column, only: [:show, :edit, :update, :destroy]

  def index
    @columns = @board.columns
  end

  def show
    board_issues = @board.repos.collect(&:issues).flatten.reject { |i| i.state == 'closed' }
    @issues = board_issues.select { |i| i.labels.any? { |l| l.name == @column.label_name } }
  end

  def new
    @column = @board.columns.build
  end

  def create
    @column = @board.columns.build(columns_params)

    if @column.save
      redirect_to board_columns_path
    end
  end

  def edit
  end

  def update
    if @column.update(columns_params)
      redirect_to board_columns_path(@board, @column), notice: 'Column was successfully updated.'
    end
  end

  def destroy
    @column.destroy
    redirect_to board_columns_path, notice: 'Column was successfully destroyed.'
  end

  private
    def columns_params
      params.require(:column).permit(:board_id, :label_name)
    end

    def set_board
      @board = Board.find(params[:board_id])
    end

    def set_column
      @column = @board.columns.find(params[:id])
    end
end
