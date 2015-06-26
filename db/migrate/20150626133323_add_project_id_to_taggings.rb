class AddProjectIdToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :project_id, :integer, index: true
  end
end
