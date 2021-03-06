class AdminTagsController < ApplicationController
  layout 'admin'

  before_action :authorize_admin!

  def index
    @tags = ActsAsTaggableOn::Tag.joins(:taggings).
      where(taggings: {context: 'public_tags'}).
      order(taggings_count: :desc).includes(:taggings)
    if params[:name]
      @tags = @tags.where('name LIKE :q', q: "%#{params[:name]}%")
    end
    @tag_pages, @tags = paginate @tags, :per_page => 25
  end

  def destroy
    tag = ActsAsTaggableOn::Tag.find(params[:id])
    taggings = tag.taggings.where(context: "public_tags")
    taggings.each { |t| t.destroy! }
    redirect_to action: :index
  end

  private

  def authorize_admin!
    deny_access unless User.current.admin?
  end
end
