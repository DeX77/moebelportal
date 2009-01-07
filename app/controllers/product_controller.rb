class ProductController < ApplicationController
  
  def index
    @products = @tm.get("http://www.uni-leipzig.de/tmp/types/product").instances
  end
end
