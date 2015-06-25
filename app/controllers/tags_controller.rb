class TagsController < ApplicationController

  before_action :set_variables
  before_action :authorize

  def create_private
    tags_list = @issue.owner_tags_on(@user, :private_tags).pluck(:name)
    tags_list << params[:value]

    if @user.tag(@issue, with: tags_list, on: :private_tags)
      render json: {
        status: 'success',
        tags:  @issue.owner_tags_on(@user, :private_tags).pluck(:name)
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
        tags: @issue.tag_counts_on(:public_tags).pluck(:name, :taggings_count)
       }
    else
      render json: { status: 'failure' }, status: 400
    end
  end

  private


  def set_variables
    @user = User.current
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
  end
end
