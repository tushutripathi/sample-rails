class EnableExtensions < ActiveRecord::Migration[6.0]
  def change
    # for uuid pk if needed
    enable_extension 'pgcrypto'

    # very good indexing for tsvector, say array for eg.
    enable_extension 'btree_gin'

    # more lightweight in terms of memory but takes more time to search
    enable_extension 'btree_gist'

    # great for partial string search using trigrams
    enable_extension 'pg_trgm'
  end
end
