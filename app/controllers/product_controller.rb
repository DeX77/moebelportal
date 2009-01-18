class ProductController < ApplicationController
  
  def index
    @type = @tm.get(@base_locator + "/types/product")
    @products = @tm.get(@base_locator + "/types/product").instances

    @manual_count = Hash.new
    for product in @products
      @manual_count[product.id] = product.counterplayers(:atype => @base_locator+"/association/manual_of").size
    end
  end
  
  def show
    @id = params[:id].to_i
    @product = @tm.topic_by_id(@id)
    @manuals = @product.counterplayers(:atype => @base_locator+"/association/manual_of")
    @acc_manuals = @tm.get( @base_locator+"/association/manual_of")
  end
  def create
    
  end
  
  def new
    
  end
  
  def update
    
  end
  
  def destroy
    #Topic Nummer
    @id = params[:id].to_i
    #Aktuelles Produkt
    @product = @tm.topic_by_id(@id)
    @tm.destroy(@product)
  end
end
