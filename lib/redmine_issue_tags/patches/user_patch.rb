require_dependency 'user'

module RedmineIssueTags
  module Patches
    module UserPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          acts_as_tagger
        end
      end
      module InstanceMethods

        def owned_private_tags
          owned_tags.joins(:taggings).
            where(taggings: {context: "private_tags"}).
            order(taggings_count: :desc)
        end

        def globally_allowed_public_tags
          scope = ActsAsTaggableOn::Tag.joins(:taggings).
            where(taggings: {context: 'public_tags'}).
            order(taggings_count: :desc)
          if admin?
            scope.distinct
          else
            allowed_project_ids = allowed_projects_public_tags.map(&:id)
            scope.where(taggings: {project_id: allowed_project_ids}).distinct
          end
        end

        def allowed_projects_public_tags
          @allowed_projects_public_tags ||= admin? ? Project.all :
            projects.select {|p| allowed_to?(:view_public_tags, p)}
        end

        def allowed_to_private_tags_globally?
          return true if User.current.admin?
          projects.any? { |p| allowed_to?(:manage_private_tags, p) }
        end
      end
    end
  end
end
