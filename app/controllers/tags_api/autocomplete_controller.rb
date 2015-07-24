module TagsApi
  class AutocompleteController < ApplicationController

    before_action :set_user

    def private
      name = params[:name]
      tags = @user.owned_private_tags.where('name LIKE :q', q: "%#{name}%").pluck_to_hash(:name)
      render json: { tags: tags }
    end

    def public
      name = params[:name]
      tags = @user.globally_allowed_public_tags.where('name LIKE :q', q: "%#{name}%").pluck_to_hash(:name)
      render json: { tags: tags }
    end

    private

    def set_user
      @user = User.current
    end
  end
end
