# encoding: utf-8

Redmine::Plugin.register :redmine_issue_tags do
  name 'Redmine Issue Tags'
  author 'Jacek Grzybowski'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/efigence/redmine_issue_tags'
  author_url 'https://github.com/efigence'

  project_module :issue_tracking do
    permission :manage_private_tags, {:tags => [:create_private, :destroy_private_tagging]}, :read => true, :require => :member
    permission :manage_public_tags, {:tags => [:create_public, :destroy, :destroy_public_tagging]}, :require => :member
    permission :view_public_tags, {}, :read => true, :require => :member
  end
end

ActionDispatch::Callbacks.to_prepare do
  require 'redmine_issue_tags/hooks/issue_sidebar_hook'
  require 'redmine_issue_tags/hooks/layout_hook'

  require 'application_helper'
  ApplicationHelper.send :include, TagsHelper

  Redmine::MenuManager.map :admin_menu do |menu|
    menu.push :tags, {:controller => 'admin_tags', :action => 'index'}, :caption => :label_tags
  end

  ProjectsHelper.send(:include, RedmineIssueTags::Patches::ProjectsHelperPatch)
  Issue.send(:include, RedmineIssueTags::Patches::IssuePatch)
  IssueQuery.send(:include, RedmineIssueTags::Patches::IssueQueryPatch)
  Project.send(:include, RedmineIssueTags::Patches::ProjectPatch)
  User.send(:include, RedmineIssueTags::Patches::UserPatch)
end
