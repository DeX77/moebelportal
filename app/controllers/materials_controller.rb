class MaterialsController < ApplicationController
  private
  def topicType
    return @base_locator + "/types/material" 
  end
  
  public
  
  def index
    @materials = @tm.get(topicType).instances
    if (@materials.size < 1)
      redirect_to root_url 
    end
  end
  
  def show
    @id = params[:id].to_i
    @material = @tm.topic_by_id(@id)
    if (@tm.get(topicType).instances.include?(@material))
      @acc_needed = @tm.get(@base_locator+"/association/material_of_step")
      @needed_at = @material.counterplayers(:atype => @base_locator+"/association/material_of_step")
      @acc_construction = @tm.get(@base_locator+"/association/construction")
      @construction = @material.counterplayers(:atype => @base_locator+"/association/construction")
      @acc_belongsTo = @tm.get(@base_locator+"/association/belongsTo")
      @belongsto = @material.counterplayers(:atype => @base_locator+"/association/belongsTo")
    else
      redirect_to materials_url
    end
    
  end
  
  def create        
    redirect_to(material_url(createTopic(params).id))   
  end
  
  def update
    
  end
  
  
end
