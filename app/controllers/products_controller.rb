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

  def manualof
    @id = params[:id].to_i

    @product = @tm.topic_by_id(@id)
    @acc_manuals = @tm.get( @base_locator+"/association/manual_of")
    @hash = Hash.new
    if (@tm.get(topicType).instances.include?(@product))
      @manuals = @tm.get(@base_locator + "/types/manual").instances
      for manual in @manuals
        @hash[get_label(manual)] = manual.id
      end
    end
  end

  def create_manualof
    @id = params[:id].to_i
    @manual_id = params[:manual_id].to_i
    @product = @tm.topic_by_id(@id)
    @manual = @tm.topic_by_id(@manual_id)

    create_association(@base_locator+"/association/manual_of",@product,@base_locator+"/types/role_product",@manual,@base_locator+"/types/role_manual")        
    redirect_to(product_url(@id))   
  end
  
end
