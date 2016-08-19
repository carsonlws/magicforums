class AddSlugToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :slug, :string, unique: true
    add_index :topics, :slug, unique: true
  end
end
