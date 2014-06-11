Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do 
      resources :appointments, except: [:new,:edit,:show]
    end
  end  
end
