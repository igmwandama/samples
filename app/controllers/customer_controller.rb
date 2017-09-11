class CustomerController < ApplicationController
    def list
        @customers = Customer.all
    end

    # GET /customer/all
    # GET /customer/all.json
    def all
        @customers = Customer.all
    end

    # GET /customer/show.json/id
    def show
        @customer =  Customer.find(params[:id])
    end

    def new
        @customer = Customer.new
    end

    #POST /customer/new
    #POST /customer/new.json
    def add
        @customer = Customer.new(customer_params)
        
        #save the person
        if @customer.save
            respond_to  do |format|
                format.json {render :json =>{:done=>true, :data=>@customer}}
                format.html {redirect_to :action => 'list'}
            end
        else
            respond_to format do |f|
                format.json {render json: @customer.errors, status: :unprocessable_entity }
                format.html {redirect_to :action => 'new', notice:@customer.errors.full_messages}
            end
            
        end
    end
    
    def edit
        
    end

    def update_params
        params.require(:customer).permit(:FirstName, :LastName, :Email, :PhoneNo)
    end


    def customer_params
        params.require(:customer).permit(:CustomerNo, :FirstName, :LastName, :Email, :PhoneNo, :PIN)
    end
end