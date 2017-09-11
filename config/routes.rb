Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'about#about'
  get  'customer/list'
  get  'customer/all'
  get  'customer/new'
  post 'customer/add'
  get  'customer/show'
  
  scope '/' do
    get '/' => 'about#about'
    get '/about' => 'about#about'
  end

  get 'account/new'
  post 'account/add'
  scope '/account' do
    get '/' => 'account#index'
   scope '/:AccountNo' do
      get '/' => 'account#details'
      get '/deposit' => 'account#deposit'
      post '/post' => 'account#push'
      get '/transfer' => 'account#ftshare'
      post '/transfer' => 'account#transfer'
    end
  end
end
