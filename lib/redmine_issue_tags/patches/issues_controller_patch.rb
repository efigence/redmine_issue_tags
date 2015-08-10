require_dependency 'issues_controller'

module RedmineIssueTags
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.class_eval do
          include TagsHelper
          helper :tags
        end
      end
    end
  end
end
