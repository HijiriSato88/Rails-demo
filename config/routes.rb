Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      
      post 'register', to: 'users#register'
      get 'index', to: 'users#index'
      get ':id/details', to: 'users#details'
      patch ':id/update', to: 'users#update'
      delete ':id/delete', to: 'users#delete'

    end
  end
end
