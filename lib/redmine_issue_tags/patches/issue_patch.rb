require_dependency 'issue'

module RedmineIssueTags
  module Patches
    module IssuePatch

      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          acts_as_taggable_on :private_tags, :public_tags

        end
      end

      module InstanceMethods
      end
    end
  end
end
