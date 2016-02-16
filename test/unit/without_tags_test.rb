require File.expand_path('../../test_helper', __FILE__)

class WithoutTagsTest < ActiveSupport::TestCase

  def setup
    @project = Project.find(11)
    @query = IssueQuery.new(:project => @project, :name => '_')
  end

  def test_user_has_correct_sql_for_without
    @query = IssueQuery.new(:name => '_')
    User.current = users(:admin)
    @query.add_filter('public_tag_id', '!*')
    statement = "(tags.id IS NULL OR tags.id NOT IN (SELECT DISTINCT tag_id FROM tags INNER JOIN taggings ON tags.id = taggings.tag_id WHERE taggings.context = 'public_tags'))"
    assert @query.statement.include?(statement)
  end

  def test_user_has_correct_sql_for_with
    @query = IssueQuery.new(:name => '_')
    User.current = users(:admin)
    @query.add_filter('public_tag_id', '*')
    statement = "(tags.id IN (SELECT DISTINCT tag_id FROM tags INNER JOIN taggings ON tags.id = taggings.tag_id WHERE taggings.context = 'public_tags'))"
    assert @query.statement.include?(statement)
  end

  def test_user_has_correct_private_tags_for_with_1
    User.current = users(:wacek)
    @query.add_filter('private_tag_id', '*')
    selectable = @query.send(:selectable_private_tags)
    tag_names = selectable.map(&:first)
    assert_not tag_names.include?("test_tag_11")
    assert tag_names.include?("test_tag_12")
    assert tag_names.size, 1
  end

  def test_user_has_correct_private_tags_for_with_2
    User.current = users(:krzysio)
    @query.add_filter('private_tag_id', '*')
    selectable = @query.send(:selectable_private_tags)
    tag_names = selectable.map(&:first)
    assert_not tag_names.include?("test_tag_12")
    assert tag_names.include?("test_tag_11")
    assert tag_names.size, 1
  end

  def test_user_has_correct_private_tags_for_without_1
    User.current = users(:wacek)
    @query.add_filter('private_tag_id', '!*')
    selectable = @query.send(:selectable_private_tags)
    tag_names = selectable.map(&:first)
    assert tag_names.include?("test_tag_12")
    assert_not tag_names.include?("test_tag_11")
    assert tag_names.size, 1
  end

  def test_user_has_correct_private_tags_for_without_2
    User.current = users(:krzysio)
    @query.add_filter('private_tag_id', '!*')
    selectable = @query.send(:selectable_private_tags)
    tag_names = selectable.map(&:first)
    assert tag_names.include?("test_tag_11")
    assert_not tag_names.include?("test_tag_12")
    assert tag_names.size, 1
  end
end
