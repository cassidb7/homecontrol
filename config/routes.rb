Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "lights#index"

  resources :attachments, only: [:show, :new, :create] do
    get :read_plate, on: :collection
  end

  resources :config_settings

  resources :lights, only: [:index, :show] do
    get :find_hue, :get_all_lights_info, on: :collection
    patch :turn_off, :turn_on, :dim_settings, on: :collection
  end

end
