#json.partial! "customer/customer", customer: @customer
json.created @customer, partial: 'customer/customer', as: :customer