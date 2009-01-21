class ToolsController < ApplicationController
  
  private
  def topicType
    return @base_locator + "/types/tool" 
  end
  
  public
  
  def index
    @tools = @tm.get(topicType).instances
    if (@tools.size < 1)
      redirect_to home_url 
    end
  end
  
  def show
    #ID aus Request
    @id = params[:id].to_i
    #Schritt aus Topic Map holen    
    @tool = @tm.topic_by_id(@id)
    
    if (@tm.get(topicType).instances.include?(@tool))
      @labels = @tool.counterplayers(:atype => @base_locator+"/association/scoping")
      @acc = @tm.get(@base_locator+"/association/tools_of_step")
      @steps = @tool.counterplayers(:atype => @base_locator+"/association/tools_of_step", :rtype => @base_locator+"/types/role_tool")
    else
      redirect_to tools_url 
    end
  end  
  
  
  def create        
    redirect_to(tool_url(createTopic(params).id))   
  end
  
  def update
    
  end
  
  
end
