post '/tags/private' => "tags#create_private", as: 'private_tags'
post '/tags/public' => "tags#create_public", as: 'public_tags'


scope :admin do
  resources :tags, only: [:index, :destroy], controller: 'admin_tags', as: 'admin_tags'
end

