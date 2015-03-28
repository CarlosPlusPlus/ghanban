class Boards::ColumnsController < ApplicationController
  before_action :find_board, only: [:index, :new, :create]

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
  end

  def destroy
  end

  private
    def columns_params
      params.require(:column).permit(:board_id, :label_name)
    end

    def find_board
      @board = Board.find(params[:board_id])
    end
end
