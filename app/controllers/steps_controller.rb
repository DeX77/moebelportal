class StepsController < ApplicationController
  private
  def topicType
    return @base_locator + "/types/step" 
  end
  
  public
  def index
    @steps = @tm.get(topicType).instances
    if (@steps.size < 1)
      redirect_to home_url 
    end
  end
  
  def show
    #ID aus Request
    @id = params[:id].to_i
    #Schritt aus Topic Map holen
    @step = @tm.topic_by_id(@id)
    if (@tm.get(topicType).instances.include?(@step))
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
    else
      redirect_to:controller => "step", :action => "index" 
    end
  end
  
  def create        
    redirect_to(step_url(createTopic(params).id))   
  end
  
  def update
    
  end
  
end
