class User < ActiveRecord::Base
  attr_accessible :com_id, :name, :password, :user_type
  validates :name, presence: true,uniqueness: true
  validates :password, presence: true
  validates :com_id, presence: true
  validates :user_type, presence: true
  has_many :operationlogs
end
