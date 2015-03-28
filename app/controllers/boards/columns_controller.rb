class Boards::ColumnsController < ApplicationController

  def index
    @board = Board.find(params[:board_id])
    @columns = @board.columns
  end

  def show
    
  end

  def new
    @board = Board.find(params[:board_id])
    @column = @board.columns.build
  end

  def create
    @board = Board.find(params[:board_id])
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

end