require_dependency 'projects_helper'

module RedmineIssueTags
  module Patches
    module ProjectsHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          alias_method_chain :project_settings_tabs, :tags
        end
      end
      module InstanceMethods
        def project_settings_tabs_with_tags
          tabs = project_settings_tabs_without_tags

          if User.current.allowed_to?(:manage_public_tags, @project)
            tabs << {
              name: 'tags',
              action: :manage_public_tags,
              partial: 'projects/settings/tags',
              label: :project_tags_settings
            }
          end
          tabs
        end
      end
    end
  end
end
