class AddSlugToBlogs < ActiveRecord::Migration[6.0]
  def change
    add_column :blogs, :slug, :text
  end
end
