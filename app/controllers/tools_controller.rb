class ToolsController < ApplicationController
  
  private
  def topicType
    return @base_locator + "/types/tool" 
  end
  
  public
  
  def index
    @tools = @tm.get(topicType).instances
    if (@tools.size < 1)
      redirect_to:controller => "product", :action => "index" 
    end
  end
  
  def show
    #ID aus Request
    @id = params[:id].to_i
    #Schritt aus Topic Map holen    
    @tool = @tm.topic_by_id(@id)
<<<<<<< local
    if (@tm.get(topicType).instances.include?(@tool))
      @acc = @tm.get(@base_locator+"/association/tools_of_step")
      @steps = @tool.counterplayers(:atype => @base_locator+"/association/tools_of_step", :rtype => @base_locator+"/types/role_tool")
    else
      redirect_to:controller => "tool", :action => "index" 
    end
=======
    @labels = @tool.counterplayers(:atype => @base_locator+"/association/scoping")
    @acc = @tm.get(@base_locator+"/association/tools_of_step")
    @steps = @tool.counterplayers(:atype => @base_locator+"/association/tools_of_step", :rtype => @base_locator+"/types/role_tool")
>>>>>>> other
  end
  
  
  def create
    
  end
  
  def new
    @product = @tm.get!("")
    @product.add_type(topicType)
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