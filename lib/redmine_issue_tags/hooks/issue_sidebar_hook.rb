module RedmineIssueTags
  module Hooks
    class IssueSidebarHook < Redmine::Hook::ViewListener
      render_on(:view_issues_sidebar_queries_bottom, :partial => 'issues/tag_cloud', :layout => false)
    end
  end
end
