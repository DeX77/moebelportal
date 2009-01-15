class ProductController < ApplicationController
  
  def index
    @products = @tm.get(@base_locator+"/types/product").instances
  end
  
  def show
    @id = params[:id].to_i
    @product = @tm.topic_by_id(@id)
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
