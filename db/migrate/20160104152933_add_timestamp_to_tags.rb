class AddTimestampToTags < ActiveRecord::Migration
  add_column(:tags, :created_at, :datetime)
  add_column(:tags, :updated_at, :datetime)
end