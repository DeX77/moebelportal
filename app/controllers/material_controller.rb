class MaterialController < ApplicationController
  
  def index
    @materials = @tm.get(@base_locator+"/types/material").instances
    if (@materials.size < 1)
      redirect_to:controller => "product", :action => "index" 
    end
  end
  
  def show
    @id = params[:id].to_i
    @material = @tm.topic_by_id(@id)
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
    #Aktuelles Material
    @material = @tm.topic_by_id(@id)
    @tm.destroy(@material)
  end
end
