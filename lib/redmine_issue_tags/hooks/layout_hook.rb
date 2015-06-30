module RedmineIssueTags
  module Hooks
    class LayoutHook < Redmine::Hook::ViewListener
      render_on(:view_layouts_base_html_head, :partial => 'admin_tags/icon', :layout => false)
    end
  end
end
