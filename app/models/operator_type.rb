class OperatorType < ActiveRecord::Base
  has_many :operators, :dependent => :destroy  
end