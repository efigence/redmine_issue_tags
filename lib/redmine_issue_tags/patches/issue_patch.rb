require_dependency 'issue'

module RedmineIssueTags
  module Patches
    module IssuePatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          acts_as_taggable_on :private_tags, :public_tags
          after_save :set_project_id_for_tagging
        end
      end
      module InstanceMethods
        def set_project_id_for_tagging
          last_tag = taggings.last
          last_tag.update_attribute(:project_id, project_id) if last_tag
        end
        private :set_project_id_for_tagging
      end
    end
  end
end
