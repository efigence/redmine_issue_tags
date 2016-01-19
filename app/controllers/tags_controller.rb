class TagsController < ApplicationController
  include TagsHelper

  before_action :set_variables, except: :destroy
  before_action :set_variables_for_destroy, only: :destroy
  before_action :authorize

  def create_private
    tags_list = @issue.owner_tags_on(@user, :private_tags).pluck(:name)
    tags_list << params[:value]

    if @user.tag(@issue, with: tags_list, on: :private_tags)
      @user.owned_private_tags.find_by(name: params[:value]).try(:touch)
      render json: {
        status: 'success',
        tag_links: private_tag_links
       }
    else
      render json: { status: 'failure' }, status: 400
    end
  end

  def create_public
    tags_list = @issue.public_tags.pluck(:name)
    tags_list << params[:value]

    if @user.tag(@issue, with: tags_list, on: :public_tags)
      render json: {
        status: 'success',
        tag_links: public_tag_links
       }
    else
      render json: { status: 'failure' }, status: 400
    end
  end

  # destroy all public taggings for tag @ project
  def destroy
    taggings = ActsAsTaggableOn::Tagging.
      joins('INNER JOIN projects ON projects.id = taggings.project_id').
      joins(:tag).where(context: 'public_tags', tags: {name: @tag.name}, projects: {id: @project.id})
    taggings.each { |t| t.destroy! }
    redirect_to settings_project_path(@project, :tab => 'tags')
  end

  # destroy public tagging for tag @ issue
  def destroy_public_tagging
    taggings = @issue.taggings.joins(:tag).where(context: 'public_tags', tag_id: params[:tag_id])
    taggings.each { |t| t.destroy! }
    render json: {status: 'success'}
  end

  # destroy private tagging for tag @ issue @ user
  def destroy_private_tagging
    taggings = @user.owned_taggings.where(context: 'private_tags',
      taggable_id: @issue.id, tag_id: params[:tag_id])
    taggings.each { |t| t.destroy! }
    render json: {status: 'success'}
  end

  private

  def private_tag_links
    @issue.owner_tags_on(@user, :private_tags).
      pluck_to_hash(:id, :name).
      map {|t| wrap_tag_into_html(t, @issue.id, :private) }
  end

  def public_tag_links
    @issue.tag_counts_on(:public_tags).
      pluck_to_hash(:id, :name, :taggings_count).
      map {|t| wrap_tag_into_html(t, @issue.id, :public) }
  end

  def set_variables_for_destroy
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  def set_variables
    @user = User.current
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
  end
end
