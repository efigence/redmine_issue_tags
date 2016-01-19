class AddIndexToTags < ActiveRecord::Migration
  add_index :tags, [:updated_at]
end
