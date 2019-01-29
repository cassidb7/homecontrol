Rails.application.routes.draw do

  root to: "my_home#index"

  resources :attachments, only: [:show, :new, :create] do
    get :read_plate, on: :collection
  end

  resources :config_settings
  resources :devices do
    get :open_gate, on: :collection
  end

  resources :lights, only: [:index, :show] do
    get :find_hue, :get_all_lights_info, :register_bridge, on: :collection
    patch :turn_off, :turn_on, :dim_settings, on: :collection
    post :save_bridge_info, on: :collection
  end

resources :registrations

  #api
  namespace :api do
    namespace :v1 do
      resources :devices, only: [:index, :create, :show, :update, :destroy]
      resources :peripherals do
        get :handshake, :grant_access, on: :collection
        post :handshake_post, on: :collection
      end
    end
  end

   mount ActionCable.server, at: '/cable'

end
