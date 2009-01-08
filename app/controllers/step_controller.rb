class StepController < ApplicationController
  def index
    @steps = @tm.get(@base_locator+"/types/step").instances
  end
  
  def show
    @id = params[:id].to_i
    @step = @tm.topic_by_id(@id)
    @materials = @step.counterplayers(:atype => @base_locator+"/association/material_of_step")
  end
end
