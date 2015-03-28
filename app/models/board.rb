class Board < ActiveRecord::Base
  has_and_belongs_to_many :repos
  has_and_belongs_to_many :users
  has_many :columns
end
