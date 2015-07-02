require File.expand_path('../../test_helper', __FILE__)

class IssueTest < ActiveSupport::TestCase

  def setup
    @issue = Issue.first
    @project = @issue.project
    @user = users(:admin)
  end

  def test_issue_assigns_project_id_to_last_tagging_on_save
    @user.tag(@issue, with: 'test tag', on: :public_tags)
    tagging = @issue.taggings.last
    assert_equal 'test tag', tagging.tag.name
    assert_equal @project.id, tagging.project_id
  end
end
