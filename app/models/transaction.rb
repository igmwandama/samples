#class to keep all transactions
class Transaction < ActiveRecord::Base
    belongs_to :account,optional: true, :class_name => "Account"
end