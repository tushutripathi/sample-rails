class AddIndexToTitleAndContent < ActiveRecord::Migration[6.0]
  def change
    add_index :blogs, :title, using: :gist, opclass: :gist_trgm_ops
    add_index :blogs, :content, using: :gist, opclass: :gist_trgm_ops
  end
end
