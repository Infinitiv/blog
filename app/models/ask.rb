class Ask < ActiveRecord::Base
  validates :question, presence: true
end
