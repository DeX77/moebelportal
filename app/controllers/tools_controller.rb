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
    tool_tmp = params[:topic]
    number_tmp = tool_tmp[:number]
    name_tmp = tool_tmp[:name]
    image_tmp = tool_tmp[:image]
    description_tmp = tool_tmp[:description]
    
    new_tool = @tm.get!(get_Instance_from_Number(number_tmp))
    new_tool["-"] = name_tmp
    new_tool[@base_locator+ "/types/image"] = image_tmp
    new_tool.add_type(topicType)
    new_tool[@base_locator+ "/types/description"] = description_tmp
    redirect_to(tool_url(new_tool.id))   
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
