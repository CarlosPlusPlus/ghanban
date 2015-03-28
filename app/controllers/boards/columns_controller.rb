class Boards::ColumnsController < ApplicationController
  before_action :set_board
  before_action :set_column, only: [:show, :edit, :update, :destroy]

  def index
    @columns = @board.columns
  end

  def show
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
