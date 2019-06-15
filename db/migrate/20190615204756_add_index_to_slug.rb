class AddIndexToSlug < ActiveRecord::Migration[6.0]
  def change
    add_index :blogs, :slug, unique: true
  end
end
