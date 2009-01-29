class UsergroupsController < ApplicationController
  
  before_filter :authorize_admin, :except => [:show, :index]
  
  private
  def topicType
    return @base_locator + "/types/usergroup" 
  end
  
  public
  
  def index
    @type = @tm.get(topicType)
    @usergroup = @tm.get(topicType).instances
    if (@usergroup.size < 1)
      redirect_to root_url 
    end
  end
  
  def show
    #ID aus Request
    @id = params[:id].to_i
    #Schritt aus Topic Map holen    
    @usergroup = @tm.topic_by_id(@id)
    
    if (@tm.get(topicType).instances.include?(@usergroup))
      @labels = @usergroup.counterplayers(:atype => @base_locator+"/association/scoping")
      @acc_members = @tm.get(@base_locator+"/association/membership")
      @users = @usergroup.counterplayers(:atype => @base_locator+"/association/membership", :rtype => @base_locator+"/role/group")
    else
      redirect_to usergroups_url 
    end
  end  
  
end
