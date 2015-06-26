require_dependency 'project'

module RedmineIssueTags
  module Patches
    module ProjectPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
        end
      end
      module InstanceMethods
        def public_tags
          ActsAsTaggableOn::Tag.joins(:taggings).
            where(taggings: {project_id: id, context: 'public_tags'}).
            distinct
        end

        def private_tags(user=User.current)
          ActsAsTaggableOn::Tag.joins(:taggings).
            where(taggings: {project_id: id, context: 'private_tags', tagger_id: user.id}).
            distinct
        end
      end
    end
  end
end
