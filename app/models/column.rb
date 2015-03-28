class Column < ActiveRecord::Base
  belongs_to :board
  has_and_belongs_to_many :issues

  def assign_column_issues(name = nil)
    board_issues = board.repos.collect(&:issues).flatten.reject { |i| i.state == 'closed' }
    self.issues  = board_issues.select { |i| i.labels.any? { |l| l.name == (name || label_name) } }       
  end

  def update(params)
    issues.clear
    assign_column_issues(params[:label_name])
    super(params)
  end
end
