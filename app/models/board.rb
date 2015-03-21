class Board < ActiveRecord::Base
  has_many :labels

  has_and_belongs_to_many :repos
  has_and_belongs_to_many :users
end
