post '/tags/private' => "tags#create_private", as: 'private_tags'
post '/tags/public' => "tags#create_public", as: 'public_tags'
delete '/tags/:id' => "tags#destroy", as: 'tag'
delete '/issues/:issue_id/public_tags/:tag_id' => "tags#destroy_public_tagging", as: 'destroy_public_tagging'
delete '/issues/:issue_id/private_tags/:tag_id' => "tags#destroy_private_tagging", as: 'destroy_private_tagging'

scope :admin do
  resources :tags, only: [:index, :destroy], controller: 'admin_tags', as: 'admin_tags'
end

namespace :tags_api do
  get '/private' => "autocomplete#private"
  get '/public' => "autocomplete#public"
end
