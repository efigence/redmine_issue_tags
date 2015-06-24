# encoding: utf-8

Redmine::Plugin.register :redmine_issue_tags do
  name 'Redmine Issue Tags'
  author 'Jacek Grzybowski'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/efigence/redmine_issue_tags'
  author_url 'https://github.com/efigence'
end

ActionDispatch::Callbacks.to_prepare do
  Issue.send(:include, RedmineIssueTags::Patches::IssuePatch)
end
