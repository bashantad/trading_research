Rails.application.routes.draw do
  resources :traffics do
  	collection do
		get :groups
		get :get_details
  	end
  end
  root :to => "traffics#index"
end
