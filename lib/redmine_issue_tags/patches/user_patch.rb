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
      end
    end
  end
end
