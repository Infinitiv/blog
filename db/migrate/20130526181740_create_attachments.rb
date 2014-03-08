class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :article, index: true
      t.string :title, :null => false, :default => ""
      t.string :mime_type, :null => false, :default => ""
      t.binary :data
      t.binary :thumbnail

      t.timestamps
    end
  end
end
