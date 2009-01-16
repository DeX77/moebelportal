class ToolController < ApplicationController
  def index
    @tools = @tm.get(@base_locator+"/types/tool").instances
    if (@tools.size < 1)
      redirect_to:controller => "product", :action => "index" 
    end
  end
  
  def show
    #ID aus Request
    @id = params[:id].to_i
    #Schritt aus Topic Map holen    
    @tool = @tm.topic_by_id(@id)
    @acc = @tm.get(@base_locator+"/association/tools_of_step")
    @steps = @tool.counterplayers(:atype => @base_locator+"/association/tools_of_step", :rtype => @base_locator+"/types/role_tool")
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
