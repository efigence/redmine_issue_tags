class TagsController < ApplicationController
  include TagsHelper

  before_action :set_variables
  before_action :authorize

  def create_private
    tags_list = @issue.owner_tags_on(@user, :private_tags).pluck(:name)
    tags_list << params[:value]

    if @user.tag(@issue, with: tags_list, on: :private_tags)
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

  private

  def private_tag_links
    @issue.owner_tags_on(@user, :private_tags).
      pluck_to_hash(:id, :name).
      map {|t| link_to_tag t[:name], t[:id], :private_tag_id}
  end

  def public_tag_links
    @issue.tag_counts_on(:public_tags).
      pluck_to_hash(:id, :name, :taggings_count).
      map {|t| link_to_tag t[:name], t[:id], :public_tag_id, t[:taggings_count]}
  end

  def set_variables
    @user = User.current
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
  end
end
