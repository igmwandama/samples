class Account < ActiveRecord::Base
    belongs_to :customer, optional: true, :class_name => "Customer"
    has_many :transactions, :foreign_key => "AccountNo", :class_name => "Transaction"
end