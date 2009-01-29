ActionController::Routing::Routes.draw do |map|  
  # The priority is based upon order of creation: first created -> highest priority.

  map.root :controller => "products" 
  
  map.resources :products
  map.resources :steps
  map.resources :manuals
  map.resources :materials
  map.resources :languages
  map.resources :tools
  map.resources :users
  map.resources :usergroups

  map.json_with_text ':controller/json/:id',  :action => 'index_json'

  map.switch_lang ':controller/switch/:id', :action => 'switch'

  map.manualof ':controller/manualof/:id', :action => 'manualof'
  map.contains ':controller/contains/:id', :action => 'contains'
  map.doafter ':controller/doafter/:id', :action => 'doafter'
  map.dobefore ':controller/dobefore/:id', :action => 'dobefore'
  map.result ':controller/result/:id', :action => 'result'
  map.materialof ':controller/materialof/:id', :action => 'materialof'
  map.toolof ':controller/toolof/:id', :action => 'toolof'
  map.childof ':controller/childof/:id', :action => 'childof'
  map.view_translate ':controller/view_translate/:id', :action => 'view_translate'
  
  map.post ':controller/create_manualof/', :action => 'create_manualof'
  map.post ':controller/create_contains/', :action => 'create_contains'
  map.post ':controller/create_doafter/', :action => 'create_doafter'
  map.post ':controller/create_dobefore/', :action => 'create_dobefore'
  map.post ':controller/create_result/', :action => 'create_result'
  map.post ':controller/create_materialof/', :action => 'create_materialof'
  map.post ':controller/create_toolof/', :action => 'create_toolof'
  map.post ':controller/create_childof/', :action => 'create_childof'

  map.post ':controller/set_translation/', :action => 'set_translation'
  map.post ':controller/:id/update/', :action => 'update'

  
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
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end
  
  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  
  # See how all your routes lay out with "rake routes"
  
  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
