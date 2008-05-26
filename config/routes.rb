ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'static', :action => 'welcome'
  
  map.with_options(:controller => 'static', :conditions => { :method => :get }) do |m|
    m.connect 'docs/terms_of_service', :action => 'terms_of_service'
    m.connect 'docs/privacy_policy', :action => 'privacy_policy'
    m.connect 'docs/about_us', :action => 'about_us'
    m.connect 'docs/tour', :action => 'tour'
  end
  
  map.with_options(:controller => 'accounts') do |m|
    m.with_options(:conditions => { :method => :get }) do |n|
      n.connect 'accounts/login', :action => 'login'
      n.connect 'accounts/signup', :action => 'signup'
      n.connect 'accounts/logout', :action => 'logout'
    end
    m.with_options(:conditions => { :method => :post }) do |n|
      n.connect 'accounts/login/password', :action => 'password_login'
      n.connect 'accounts/signup/password', :action => 'password_signup'
    end
  end
  
  map.with_options(:controller => 'profiles') do |m|
    m.connect 'refer_a_friend', :action => 'refer_a_friend'
    m.with_options(:conditions => { :method => :get }) do |n|
      n.connect 'dashboard', :action => 'dashboard'
      n.connect 'getting_started', :action => 'getting_started'
      n.connect 'people/:profile_id', :action => 'show'
      n.connect 'people/:profile_id/edit', :action => 'edit'
    end
    m.with_options(:conditions => { :method => :post }) do |n|
      n.connect 'people/:profile_id/update', :action => 'update'
    end
  end
  
  map.with_options(:controller => 'friends') do |m|
    m.with_options(:conditions => { :method => :get }) do |n|
      n.connect 'people/:profile_id/following', :action => 'following'
      n.connect 'people/:profile_id/following/tier/:tier', :action => 'following_by_tier'
      n.connect 'people/:profile_id/followers', :action => 'followers'
      n.connect 'people/:profile_id/friends', :action => 'friends'
    end
    m.with_options(:conditions => { :method => :post }) do |n|
      n.connect 'people/:profile_id/follow', :action => 'follow'
      n.connect 'people/:profile_id/unfollow', :action => 'unfollow'
      n.connect 'people/:profile_id/move_to_tier', :action => 'move_to_tier'
    end
  end

  map.with_options(:controller => 'location') do |m|
    m.with_options(:conditions => { :method => :get }) do |n|
      n.connect 'people/:profile_id/location', :action => 'current'
      n.connect 'people/:profile_id/location/edit', :action => 'edit'
      n.connect 'whos_around', :action => 'whos_around'
    end
    m.with_options(:conditions => { :method => :post }) do |n|
      n.connect 'people/:profile_id/location/update', :action => 'update'
    end
  end

  map.with_options(:controller => 'favorite_locations') do |m|
    m.with_options(:conditions => { :method => :get }) do |n|
      n.connect 'people/:profile_id/location/favorites', :action => 'list'
      n.connect 'people/:profile_id/location/favorites/add', :action => 'add'
      n.connect 'people/:profile_id/location/favorites/:favorite_location_id/edit', :action => 'edit'
    end
    m.with_options(:conditions => { :method => :post }) do |n|
      n.connect 'people/:profile_id/location/favorites/create', :action => 'create'
      n.connect 'people/:profile_id/location/favorites/:favorite_location_id/delete', :action => 'delete'
      n.connect 'people/:profile_id/location/favorites/:favorite_location_id/update', :action => 'update'
    end
  end
end
