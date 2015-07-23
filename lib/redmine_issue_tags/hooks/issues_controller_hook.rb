module RedmineIssueTags
  module Hooks
    class IssuesControllerHook < Redmine::Hook::ViewListener
      def controller_issues_new_after_save(context={})
        tag_issue(:private, context)
        tag_issue(:public,  context)
      end

      private

      def tag_issue(kind, context={})
        tags = context[:params]["issue_#{kind}_tags"]
        User.current.tag(context[:issue], with: tags, on: "#{kind}_tags") if tags
      end
    end
  end
end
