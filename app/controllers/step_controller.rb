class StepController < ApplicationController
  def index
    @steps = @tm.get(@base_locator+"/types/step").instances
    if (@steps.size < 1)
      redirect_to:controller => "product", :action => "index" 
    end
  end
  
  def show
    #ID aus Request
    @id = params[:id].to_i
    #Schritt aus Topic Map holen
    @step = @tm.topic_by_id(@id)
    #Teilschritte holen
    @acc_hierachie = @tm.get(@base_locator+"/association/parts_of_steps")
    @parts_of_steps = @step.counterplayers(:atype => @base_locator+"/association/parts_of_steps", :rtype => @base_locator+"/types/role_supstep")
    #uebergeordneter Schritt
    @parentstep = @step.counterplayers(:atype => @base_locator+"/association/parts_of_steps", :rtype => @base_locator+"/types/role_substep")
    @acc_material = @tm.get(@base_locator+"/association/material_of_step")
    @materials = @step.counterplayers(:atype => @base_locator+"/association/material_of_step" , :rtype => @base_locator+"/types/role_step")
    @acc_tools = @tm.get(@base_locator+"/association/tools_of_step")
    @tools = @step.counterplayers(:atype => @base_locator+"/association/tools_of_step")
    @acc_result = @tm.get(@base_locator+"/association/construction")
    @results = @step.counterplayers(:atype => @base_locator+"/association/construction")
    @acc_sequence = @tm.get(@base_locator+"/association/sequence_of_steps")
    @doBefore = @step.counterplayers(:atype => @base_locator+"/association/sequence_of_steps", :rtype => @base_locator+"/types/role_following_step")
    @doAfter = @step.counterplayers(:atype => @base_locator+"/association/sequence_of_steps", :rtype => @base_locator+"/types/role_earlier_step")
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
