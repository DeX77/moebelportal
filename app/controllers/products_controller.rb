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
      redirect_to :controller => "product", :action => "index"
    end
  end
  
  def create
    product_tmp = params[:product]
    number_tmp = product_tmp[:number]
    name_tmp = product_tmp[:name]
    image_tmp = product_tmp[:image]
    description_tmp = product_tmp[:description]
    
    new_product = @tm.get!(get_Instance_from_Number(number_tmp))
    new_product["-"] = name_tmp
    new_product["image"] = image_tmp
    #new_product["description"] = description_tmp
    new_product.add_type(topicType)
    redirect_to(product_url)   
  end
  
  def new
    product = @tm.get!("")
    product.add_type(topicType)
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
