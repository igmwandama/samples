class AccountController < ApplicationController
    def show
    end

    def index
        @accounts = Account.all
        respond_to do |format|
            format.json { render :json =>{:data => @accounts}}
            format.html {}
        end
    end

    #render new account page
    def new
        @customer = Customer.find(params[:id])
        if @customer
            @account = Account.new
            @account.CustomerNo = @customer.CustomerNo
        else
            
        end
    end

    def ftshare
        @activity = Activity.new
        @account = params[:AccountNo]
    end

    #post
    #transfer.json(dest, amount)
    def transfer
         amount = deposit_params[:Amount].to_f
         @error = ""
         @message = ""
         done = false
         #render :json => {:from => params[:AccountNo], :to => deposit_params[:AccountNo], :amount => deposit_params[:Amount]}

         #check the recieving account if its valid
         @destination = Account.find(deposit_params[:AccountNo])
         if @destination
            @account = Account.find(params[:AccountNo])
            if @account
                #make sure the balance is below minimum of 500.0
                if @account.Balance - amount > 500.0
                    @account.Balance -= amount
                    if @account.save
                        #save transaction
                        tid = rand_tid
                        desc = "Fund Transfer by OBank. " + Customer.find(@account.CustomerNo).FirstName + Customer.find(@account.CustomerNo).LastName
                        create_trans(@account.AccountNo, amount.to_f, "DR", tid, desc) #save the debit transaction

                        @destination.Balance += amount;
                        if @destination.save 
                            create_trans(@destination.AccountNo, amount.to_f, "CR", tid, desc) #save the debit transaction
                            #all done yeep yey!
                            done = true
                            message = "Funds transfer to " + @destination.AccountNo  + " was successful. Thank You"
                           
                        else
                            error = "Transfer Failed, Balance Restored"
                            #handle the fail, not nice though
                            Transaction.destroy(tid)
                            @account.Balance += amount
                            @account.save
                        end

                    else
                        error = @account.errors.full_messages
                    end
                else
                    error = "Transfer Failed - Insufficient Funds"
                end
            else
                #source account not valid
                error = "Sending Account Invalid!"
            end
        else
            #not found - destination
            error = "Receiving Account Does Not Exists!"
        end


        #render the messages
        if done == true
            respond_to do |format|
                format.json { render :json =>{:success => true, :message => message}}
                format.html {redirect_to :action => 'details'}
            end
        else 
            respond_to do |format|
                format.json { render :json =>{:success => false, :message => error}}
                format.html {redirect_to :action => 'details'}
            end
        end
    end

    #deposit money to account
    #post /account/push
    def push
        @account = Account.find(deposit_params[:AccountNo])
        if @account
            bal = @account.Balance
            @account.Balance += deposit_params[:Amount].to_f

            if @account.save
                #create a transaction
                tid = rand_tid

                cr = "CR"

                desc = "Teller Account Deposit OBank"

                create_trans(@account.AccountNo, deposit_params[:Amount].to_f, cr, tid, desc)

                #all is done, render a saved message
                respond_to do |format|
                    format.json { render :json => { :response =>{ :success=>true, :AccountNo => @account.AccountNo, 
                                                    :BalanceBefore => bal, :Amount => deposit_params[:Amount], :BalanceAfter => @account.Balance, :Type => cr}}}
                    format.html { redirect_to :action => 'details'}
                end
            else
                respond_to do |format|
                    format.json { render :json => {:response =>{:success=>false, :message=>"Error Depositing Money"}}}
                    format.html {redirect_to :action => 'details', notice: "Error Depositing Money"}
                end
            end
        else
            respond_to do |format|
                format.json { render :json => {:response =>{:success=>false, :message=>"Invalid Account Number"}}}
                format.html {redirect_to :action => 'details', notice: "Invalid Account Number"}
            end
        end
    end

    #render deposit form
    def deposit
        @activity = Activity.new
        @activity.AccountNo = params[:AccountNo]
    end


    #view account details
    def details
        @error = ""
        @message = ""
        @account = Account.find(params[:AccountNo])
        if @account
            @customer = Customer.find(@account.CustomerNo)
            if @customer
                #every thing is fine, lets render message
                @transactions  = @account.transactions
                respond_to do |format|
                    format.json { render :json => { :respose =>{:account => {:AccountNo => @account.AccountNo,
                     :Balance => @account.Balance, :transactions => @account.transactions}, :customer => @customer}}}

                    format.html {}
                end
            else
                respond_to do |format|
                    format.json { render :json => {:response => "Invalid Account, No Details Found"}}
                end
            end
        else
            respond_to do |format|
                format.json { render :json => {:response => "Invalid Account, No Details Found"}}
            end
        end
    end

    #add new account
    def add
        @account = Account.new(add_params)
        
        #save the person
        if @account.save
            respond_to do |f|
                f.json { render :json => {:success => true, :data => @account}}
                f.html {redirect_to :action => 'details', :AccountNo => @account.AccountNo}
            end
        else
            respond_to do |f|
                f.json { render :json => {:success => false, :errors => @account.errors.full_messages}}
                f.html {redirect_to :action => 'details', :AccountNo => @account.AccountNo}
            end
        end
    end

    #clean new account data
    def add_params
        params.require(:account).permit(:AccountNo, :CustomerNo, :Balance)
    end

    #clean deposit data
    def deposit_params
        params.require(:activity).permit(:AccountNo, :Amount)
    end

    #generate random characters and numbers, length 6
    #source: stackoverflow, 
    def rand_tid
        tid = [*('A'..'Z'), *('0'..'9')].sample(6).join
        return tid
    end

    def create_trans(acc, amount, crdr, tid, desc)
        @transaction = Transaction.new
        
        require 'date'
        #set the properties
        time = Time.now #get the current time

        @transaction.Date = Date.parse(time.strftime("%Y-%m-%d"))
        @transaction.Time = time.strftime("%H:%M:%S")
        @transaction.Type = crdr
        @transaction.AccountNo = acc
        @transaction.Amount = amount
        @transaction.Description = desc
        @transaction.REF = "FT".concat(time.strftime("%y%m%d").concat(tid))
        @transaction.TID = rand_tid

        if @transaction.save
            #nothing to beat ujeni around
        else
           Rails.logger.debug @transaction.error.full_messages
        end
        
    end
end