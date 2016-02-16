require File.expand_path('../../test_helper', __FILE__)

class IssuesControllerTest < ActionController::TestCase

  def setup
    @request.session[:user_id] = 1
  end

  test "index should have public tags and private tags in sidebar" do
    get :index
    assert_response :success
    assert_no_add_tag_links
  end

  test "index for project should have tags in sidebar with add links" do
    get :index, :project_id => 1
    assert_response :success
    assert_no_add_tag_links
  end

  test "user shouldn't see private tags if not permitted" do
    @request.session[:user_id] = 2
    user = User.find(2)
    delete_user_permission(user, :manage_private_tags)
    get :index, :project_id => 1
    assert_response :success
    assert_select '#tags-wrapper' do
      assert_select "#public-tags-container"
      assert_select "#private-tags-container", false
      assert_select "a.tag", text: "test_tag_1"
      assert_select "a.tag", text: "test_tag_2"
    end
  end

  test "user shouldn't see public tags if not permitted" do
    @request.session[:user_id] = 2
    user = User.find(2)
    delete_user_permission(user, :view_public_tags)
    get :index, project_id: 1
    assert_response :success
    assert_select '#tags-wrapper' do
      assert_select "#public-tags-container", false
      assert_select "#private-tags-container"
      assert_select "a.tag", text: "test_tag_4"
    end
  end

  test "issue page should contain add tag links" do
    get :show, id: 1
    assert_response :success
    assert_add_tag_links_present
    assert_select "a.tag", text: "test_tag_1"
  end

  test "user shouldn't see add tag link for public if cannot manage" do
    @request.session[:user_id] = 2
    user = User.find(2)
    delete_user_permission(user, :manage_public_tags)
    get :show, id: 1
    assert_select '#tags-wrapper' do
      assert_select "#public-tags-container"
      assert_select "#private-tags-container"
      assert_select "#toggle-public-form", false
      assert_select "#toggle-private-form"
    end
  end

  test "project with issues with no tags should have issues visible" do
    clean_all_tags!
    @request.session[:user_id] = 2
    get :index, project_id: 1
    assert_select 'table.list.issues' do
      assert_select 'tbody' do
        assert_select 'tr.issue'
      end
    end
  end

  private

  def clean_all_tags!
    ActsAsTaggableOn::Tag.delete_all
    ActsAsTaggableOn::Tagging.delete_all
  end

  def assert_no_add_tag_links
    assert_select '#tags-wrapper' do
      assert_select '#toggle-private-form', false, "shouldn't have 'add tag' links"
      assert_select '#toggle-public-form', false, "shouldn't have 'add tag' links"
    end
  end

  def assert_add_tag_links_present
    assert_select '#tags-wrapper' do
      assert_select '#toggle-private-form'
      assert_select '#toggle-public-form'
    end
  end

  def delete_user_permission(user, permission)
    role = user.memberships.first.roles.first
    role.permissions.delete(permission)
    role.save!
  end
end
