json.extract! customer, :CustomerNo, :FirstName, :LastName, :Email, :PhoneNo
json.url customer_all_url(customer, format: :json)