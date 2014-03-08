class User < ActiveRecord::Base
  validates :login, :presence => true
  validates :password, :confirmation => true
  validates :password_confirmation, :presence => true
  
  has_many :articles
  has_many :attachments, :through => :articles
  has_secure_password
end
