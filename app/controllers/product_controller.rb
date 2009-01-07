class ProductController < ApplicationController
  
  def index
    @products = @tm.get(@base_locator+"/types/product").instances
  end
  
  def show
    @id = params[:id].to_i
    @product = @tm.topic_by_id(@id)
  end
  
end
