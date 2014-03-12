class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :article, index: true
      t.text :content
      t.boolean :published, :boolean, :null => false, :default => false

      t.timestamps
    end
  end
end
