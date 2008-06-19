ActionController::Routing::Routes.draw do |map|
  
  # The following methods can be used in block form, like so:
  #   map.html_or_api do |m|
  #     m.connect ...
  #   end
  # or to generate a defalt hash of options, like so:
  #   map.connect '...', html_get(:action => '...')
  #
  # * get
  # * post
  # * html
  # * html_or_api
  # * html_or_api_or_feeds
  # * html_get              (great for forms that can only be seen in browser)
  # * html_or_api_get       (great for data that can be seen in browser or via the API)
  # * html_or_api_post      (great for data to be updated in browser or via API)

  map.root :controller => 'static', :action => 'welcome'
  
  map.get(:controller => 'static') do |m|
    m.help_index  'docs.:format', :action => 'index'
    m.document    'docs/:page.:format', :action => 'page'
  end
  
  map.with_options(:controller => 'accounts') do |m|
    m.get do |n|
      n.login_form 'accounts/login.:format', :action => 'login'
      n.signup_form 'accounts/signup.:format', :action => 'signup'
      
      # TODO: should logout be POST only?  If so, how do we fake POST through GET?
      n.logout 'accounts/logout.:format', :action => 'logout'
    end
    
    m.post do |n|
      n.password_login 'accounts/login/password.:format', :action => 'password_login'
      n.password_signup 'accounts/signup/password.:format', :action => 'password_signup'
    end
  end
  
  map.with_options(:controller => 'profiles') do |m|
    m.get do |n|
      n.profile 'people/:profile_id.:format', :action => 'show'
      n.dashboard 'people/:profile_id/dashboard.:format', :action => 'dashboard'
      n.getting_started 'people/:profile_id/getting_started.:format', :action => 'getting_started'
      n.edit_profile 'people/:profile_id/edit.:format', :action => 'edit'
      n.refer_a_friend 'refer_a_friend.:format', :action => 'refer_a_friend_form'
    end
    
    m.put do |n|
      n.connect 'people/:profile_id.:format', :action => 'update'
    end
    
    m.post do |n|
      n.connect 'refer_a_friend.:format', :action => 'refer_a_friend'
    end
  end
  
  map.with_options(:controller => 'friends') do |m|
    m.get do |n|
      n.following 'people/:profile_id/following.:format', :action => 'following'
      n.following_by_tier 'people/:profile_id/following/tier/:tier.:format', :action => 'following_by_tier'
      n.followers 'people/:profile_id/followers.:format', :action => 'followers'
      n.friends 'people/:profile_id/friends.:format', :action => 'friends'
    end
    m.post do |n|
      n.follow 'people/:profile_id/follow.:format', :action => 'follow'
      n.unfollow 'people/:profile_id/unfollow.:format', :action => 'unfollow'
      n.move_to_tier 'people/:profile_id/move_to_tier.:format', :action => 'move_to_tier'
    end
  end

  map.with_options(:controller => 'location') do |m|
    m.get do |n|
      n.location 'people/:profile_id/location.:format', :action => 'current'
      n.whos_around 'people/:profile_id/location/whos_around.:format', :action => 'whos_around'
      n.edit_location 'people/:profile_id/location/edit.:format', :action => 'edit'
    end
    
    m.put do |n|
      n.connect 'people/:profile_id/location.:format', :action => 'update'
    end
  end
  
  map.resources :favorite_locations, :path_prefix => '/people/:profile_id/location', :as => 'favorites'
  
  map.with_options(:controller => 'settings') do |m|
    m.get do |n|
      n.edit_notifications 'people/:profile_id/settings/notifications.:format', :action => 'edit_notifications'
      n.edit_privacy 'people/:profile_id/settings/privacy.:format', :action => 'edit_privacy'
    end
    
    m.post do |n|
      n.connect 'people/:profile_id/settings/notifications.:format', :action => 'update_notifications'
      n.connect 'people/:profile_id/settings/privacy.:format', :action => 'update_privacy'
    end
  end
  
  map.get(:controller => 'css') do |m|
    # generated stylesheets (can't do a generic route, since it would hide /public/stylesheets)
    m.connect '/stylesheets/color.css', :action => 'color', :format => 'css'
    m.connect '/stylesheets/browser.css', :action => 'browser', :format => 'css'
  end
end
