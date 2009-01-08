class MaterialController < ApplicationController
  
  def index
    @materials = @tm.get(@base_locator+"/types/material").instances
  end
  
  def show
    @id = params[:id].to_i
    @material = @tm.topic_by_id(@id)
  end
end
