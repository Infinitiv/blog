class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, :null => false, :default => ""
      t.string :password_digest, :null => false, :default => ""

      t.timestamps
    end
  end
end
