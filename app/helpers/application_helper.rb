module ApplicationHelper
  def show_board_columns_link?
    params['controller'] == 'boards' && params['action'] == 'show'
  end
end
