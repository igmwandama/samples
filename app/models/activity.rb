#this class presents a debit/credit activity
class Activity 
    include ActiveModel::Model

    attr_accessor :AccountNo, :Amount

    validates_presence_of :AccountNo, presence: true, length: {in:10..10}
    validates_presence_of :Amount, presence: true
end

#account transfer model
class Transfer
    include ActiveModel::Model
    #sending account
    #receiving account
    #amount
    attr_accessor :Source, :Destination, :Amount
    validates_presence_of :Source, presence: true, length: {in:10..10}
    validates_presence_of :Destination, presence: true, length: {in:10..10}
    validates_presence_of :Amount, presence: true
end 