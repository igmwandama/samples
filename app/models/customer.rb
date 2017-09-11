class Customer < ActiveRecord::Base
    has_many :accounts, :foreign_key => "CustomerNo", :class_name => "Account"
end