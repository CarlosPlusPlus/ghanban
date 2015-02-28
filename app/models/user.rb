class User < ActiveRecord::Base
  has_and_belongs_to_many :boards

  validates :uid, :username, presence: true
  validates :uid, uniqueness: true

  def self.create_with_omniauth(auth)
    create! do |user|
      user.uid      = auth['uid']
      user.name     = auth['info']['name'] || ''
      user.username = auth['info']['nickname']
    end
  end
end
