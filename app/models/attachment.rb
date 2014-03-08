class Attachment < ActiveRecord::Base
  require 'RMagick'
  belongs_to :article
  belongs_to :user
  
    def uploaded_file=(incoming_file)
      self.title = incoming_file[:file].original_filename
      self.mime_type = incoming_file[:file].content_type
      if incoming_file[:file].content_type =~ /image/
	img = Magick::Image.read(incoming_file[:file].tempfile.path).first
	img.scale!(img.columns > img.rows ? 1024 / img.columns.to_f : 1024 / img.rows.to_f) if img.rows > 1024 || img.columns > 1024
	img.write(incoming_file[:file].tempfile.path)
      end
      self.data = incoming_file[:file].read
      self.thumbnail = thumb(self.data) if self.mime_type =~ /image/
    end

    def filename=(new_filename)
      write_attribute("filename", sanitize_filename(new_filename))
    end
    
    def title_sen_dot
      if %r{[.]} =~ title
	title.reverse.from((%r{[.].+} =~ title.reverse) + 1).reverse
      else
	title
      end
    end
    
    private
    def sanitize_filename(filename)
        #get only the filename, not the whole path (from IE)
        just_filename = File.basename(filename)
        #replace all non-alphanumeric, underscore or periods with underscores
        just_filename.gsub(/[^\w\.\-]/, '_')
    end
    
    def thumb(image)
      img = Magick::Image.from_blob(image).first
      img.resize_to_fill!(150).to_blob
    end
end
