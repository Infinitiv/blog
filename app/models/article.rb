class Article < ActiveRecord::Base
  has_many :attachments
  has_many :comments
  validates :title, :presence => true
  
  def first_image_attachment
    attachments.select {|a| a.mime_type =~ /image/}.first
  end
  
  def not_image_attachments_count
    attachments.select {|a| a.mime_type !~ /image/}.count
  end
end
