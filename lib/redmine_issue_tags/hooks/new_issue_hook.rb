module RedmineIssueTags
  module Hooks
    class NewIssueHook < Redmine::Hook::ViewListener
      render_on(:view_issues_form_details_bottom, :partial => 'issues/new_issue_hook', :layout => false)
    end
  end
end
