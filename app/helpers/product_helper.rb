module ProductHelper
  
  def getNumberOfManuals(product)
    return "(" + product.counterplayers(:atype => @base_locator+"/association/manual_of").size.to_s + ")"
  end
end
