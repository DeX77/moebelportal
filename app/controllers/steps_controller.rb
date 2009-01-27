class StepsController < ApplicationController
  private
  def topicType
    return @base_locator + "/types/step" 
  end
  
  public
  def index
    @steps = @tm.get(topicType).instances
    if (@steps.size < 1)
      redirect_to root_url 
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
      redirect_to steps_url 
    end
    
  end
  
  def create        
    redirect_to(step_url(createTopic(params)))   
  end
  
  
  def contains
    @id = params[:id].to_i
    #Aktuelles Manual
    @parent = @tm.topic_by_id(@id)
    @association = @tm.get( @base_locator+"/association/parts_of_steps")
    @hash = Hash.new
    if (@tm.get(topicType).instances.include?(@parent))
      @steps = @tm.get(@base_locator + "/types/step").instances
      for step in @steps
        if step != @parent
          @hash[get_label(step)] = step.id
        end
      end
    end
  end
  
  def create_contains
    @id = params[:id].to_i
    @step_id = params[:step_id].to_i
    @parent = @tm.topic_by_id(@id)
    @step = @tm.topic_by_id(@step_id)
    
    create_association(@base_locator+"/association/parts_of_steps",@parent,@base_locator+"/types/role_supstep",@step,@base_locator+"/types/role_substep")
    redirect_to(step_url(@id))
  end
  
  def childof
    @id = params[:id].to_i
    #Aktuelles Manual
    @parent = @tm.topic_by_id(@id)
    @association = @tm.get( @base_locator+"/association/parts_of_steps")
    @hash = Hash.new
    if (@tm.get(topicType).instances.include?(@parent))
      @steps = @tm.get(@base_locator + "/types/step").instances
      for step in @steps
        if step != @parent
          @hash[get_label(step)] = step.id
        end
      end
    end
  end
  
  def create_childof
    @id = params[:id].to_i
    @step_id = params[:step_id].to_i
    @parent = @tm.topic_by_id(@id)
    @step = @tm.topic_by_id(@step_id)
    
    create_association(@base_locator+"/association/parts_of_steps",@parent,@base_locator+"/types/role_substep",@step,@base_locator+"/types/role_supstep")
    redirect_to(step_url(@id))
  end
  
  def doafter
    @id = params[:id].to_i
    @parent = @tm.topic_by_id(@id)
    @association = @tm.get( @base_locator+"/association/sequence_of_steps")
    @hash = Hash.new
    if (@tm.get(topicType).instances.include?(@parent))
      @steps = @tm.get(@base_locator + "/types/step").instances
      for step in @steps
        if step != @parent
          @hash[get_label(step)] = step.id
        end
      end
    end
  end
  
  def create_doafter
    @id = params[:id].to_i
    @step_id = params[:step_id].to_i
    @parent = @tm.topic_by_id(@id)
    @step = @tm.topic_by_id(@step_id)
    create_association(@base_locator+"/association/sequence_of_steps",@parent,@base_locator+"/types/role_earlier_step",@step,@base_locator+"/types/role_following_step")
    redirect_to(step_url(@id))
  end
  
  def dobefore
    @id = params[:id].to_i
    @parent = @tm.topic_by_id(@id)
    @association = @tm.get( @base_locator+"/association/sequence_of_steps")
    @hash = Hash.new
    if (@tm.get(topicType).instances.include?(@parent))
      @steps = @tm.get(@base_locator + "/types/step").instances
      for step in @steps
        if step != @parent
          @hash[get_label(step)] = step.id
        end
      end
    end
  end
  
  def create_dobefore
    @id = params[:id].to_i
    @step_id = params[:step_id].to_i
    @parent = @tm.topic_by_id(@id)
    @step = @tm.topic_by_id(@step_id)
    
    create_association(@base_locator+"/association/sequence_of_steps",@parent,@base_locator+"/types/role_following_step",@step,@base_locator+"/types/role_earlier_step")
    redirect_to(step_url(@id))
    
  end
  
  def materialof
    @id = params[:id].to_i
    @step = @tm.topic_by_id(@id)
    @association = @tm.get( @base_locator+"/association/material_of_step")
    @hash = Hash.new
    if (@tm.get(topicType).instances.include?(@step))
      @materials = @tm.get(@base_locator + "/types/material").instances
      for material in @materials
        @hash[get_label(material)] = material.id
      end
    end
  end
  
  def create_materialof
    @id = params[:id].to_i
    @material_id = params[:material_id].to_i
    @step = @tm.topic_by_id(@id)
    @material = @tm.topic_by_id(@material_id)
    create_association(@base_locator+"/association/material_of_step",@step,@base_locator+"/types/role_step",@material,@base_locator+"/types/role_material")
    redirect_to(step_url(@id))
  end
  
  def result
    @id = params[:id].to_i
    @step = @tm.topic_by_id(@id)
    @association = @tm.get( @base_locator+"/association/construction")
    @hash = Hash.new
    if (@tm.get(topicType).instances.include?(@step))
      @materials = @tm.get(@base_locator + "/types/material").instances
      for material in @materials
        @hash[get_label(material)] = material.id
      end
    end
  end
  
  def create_result
    @id = params[:id].to_i
    @material_id = params[:material_id].to_i
    @step = @tm.topic_by_id(@id)
    @material = @tm.topic_by_id(@material_id)
    create_association(@base_locator+"/association/construction",@step,@base_locator+"/types/role_constructor",@material,@base_locator+"/types/role_result")
    redirect_to(step_url(@id))
  end
  
  def toolof
    @id = params[:id].to_i
    @step = @tm.topic_by_id(@id)
    @association = @tm.get( @base_locator+"/association/tools_of_step")
    @hash = Hash.new
    if (@tm.get(topicType).instances.include?(@step))
      @tools = @tm.get(@base_locator + "/types/tool").instances
      for tool in @tools
        @hash[get_label(tool)] = tool.id
      end
    end
  end
  
  def create_toolof
    @id = params[:id].to_i
    @tool_id = params[:tool_id].to_i
    @step = @tm.topic_by_id(@id)
    @tool = @tm.topic_by_id(@tool_id)
    create_association(@base_locator+"/association/tools_of_step",@step,@base_locator+"/types/role_step",@tool,@base_locator+"/types/role_tool")
    redirect_to(step_url(@id))
  end
  
end
