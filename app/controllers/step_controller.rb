class StepController < ApplicationController
  def index
    @steps = @tm.get(@base_locator+"/types/step").instances
    if (@steps.size < 1)
      redirect_to:controller => "product", :action => "index" 
    end
  end
  
  def show
    @id = params[:id].to_i
    @step = @tm.topic_by_id(@id)
    @parts_of_steps = @step.counterplayers(:atype => @base_locator+"/association/parts_of_steps")
    @materials = @step.counterplayers(:atype => @base_locator+"/association/material_of_step")
    @tools = @step.counterplayers(:atype => @base_locator+"/association/tools_of_step")
    @results = @step.counterplayers(:atype => @base_locator+"/association/construction")
    @doBefore = @step.counterplayers(:atype => @base_locator+"/association/sequence_of_steps" , :otype => @base_locator+"/types/player" )
    @doAfter = @step.counterplayers(:atype => @base_locator+"/association/sequence_of_steps" , :otype => @base_locator+"/types/player_" )
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
    #Aktueller Step
    @step = @tm.topic_by_id(@id)
    @tm.destroy(@step)
  end
end
