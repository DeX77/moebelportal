class ProductsController < ApplicationController
  
  private
  def topicType
    return @base_locator + "/types/product" 
  end
  
  public
  def index
    @type = @tm.get(topicType)
    @products = @tm.get(topicType).instances
  end
  
  def show
    @id = params[:id].to_i
    @product = @tm.topic_by_id(@id)
    if (@tm.get(topicType).instances.include?(@product))
      @manuals = @product.counterplayers(:atype => @base_locator+"/association/manual_of")
      @acc_manuals = @tm.get( @base_locator+"/association/manual_of")
    else
      redirect_to root_url
    end
  end
  
  def create        
    redirect_to(product_url(createTopic(params).id))   
  end
  
  def new
    
  end
  
  def update
    
  end  
  
end
