class Operationlog < ActiveRecord::Base
  attr_accessible :desc,:time
  belongs_to :user
end
