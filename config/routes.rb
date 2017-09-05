Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'customer#list'
  get  'customer/list'
  get  'customer/all'
  get  'customer/new'
  post 'customer/add'
  get  'customer/show'
end
