require File.expand_path('../../test_helper', __FILE__)

class IssueQueryTest < ActiveSupport::TestCase

  def setup
    @project = Project.find(1)
    @query = IssueQuery.new(:project => @project, :name => '_')
    User.current = users(:manager)
  end

  def test_selectable_public_tags_should_return_tags_added_by_different_users_for_project
    selectable = @query.send(:selectable_public_tags, @project)
    tag_names = selectable.map(&:first)
    assert tag_names.include?("test_tag_1")
    assert tag_names.include?("test_tag_2")
  end

  def test_selectable_public_tags_should_return_tags_from_all_project_issues
    selectable = @query.send(:selectable_public_tags, @project)
    tag_names = selectable.map(&:first)
    assert tag_names.include?("test_tag_6")
  end

  def test_selectable_public_tags_should_return_all_public_tags_if_project_not_set
    User.current = users(:admin)
    @query = IssueQuery.new(:name => '_')
    selectable = @query.send(:selectable_public_tags)
    tag_names = selectable.map(&:first)
    ["test_tag_1", "test_tag_2", "test_tag_3", "test_tag_6"].each do |tag|
      assert tag_names.include?(tag)
    end
  end

  def test_selectable_private_tags_should_return_only_user_tags_if_project_not_set
    User.current = users(:admin)
    @query = IssueQuery.new(:name => '_')
    selectable = @query.send(:selectable_private_tags)
    tag_names = selectable.map(&:first)
    assert tag_names.include?("test_tag_5")
    assert_not tag_names.include?("test_tag_4")
    assert_equal 2, tag_names.length
  end

  def test_public_tags_from_another_project_not_included_as_selectable
    selectable = @query.send(:selectable_public_tags, @project)
    tag_names = selectable.map(&:first)
    assert_not tag_names.include?("test_tag_3")
  end

  def test_selectable_private_tags_should_return_tags_of_current_user_only
    selectable = @query.send(:selectable_private_tags, @project)
    tag_names = selectable.map(&:first)
    assert tag_names.include?("test_tag_4")
    assert_not tag_names.include?("test_tag_1")
    assert_not tag_names.include?("test_tag_5")
  end

  def test_statement_should_include_tag_query_for_public_tags
    @query.add_filter('public_tag_id', '=', ['1'])
    assert @query.statement.include?("tags.id IN (1) AND taggings.context = 'public_tags'")
  end

  def test_statement_should_include_tag_query_for_private_tags
    @query.add_filter('private_tag_id', '=', ['4'])
    assert @query.statement.include?("tags.id IN (4) AND taggings.context = 'private_tags'")
  end

  def test_private_tags_count_should_equal_proper_value
    @project = Project.find(11)
    @query = IssueQuery.new(:project => @project, :name => '_')
    User.current = users(:wacek)
    @query.add_filter('private_tag_id', '*')
    selectable = @query.send(:selectable_private_tags)
    tag_names = selectable.map(&:first)
    assert_not tag_names.include?("test_tag_11")
    assert tag_names.include?("test_tag_12")
  end
end
