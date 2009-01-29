class UsersController < ApplicationController
  private
  def topicType
    return @base_locator + "/types/user" 
  end
  
  public
  
  def index
    @type = @tm.get(topicType)
    @user = @tm.get(topicType).instances
    if (@user.size < 1)
      redirect_to root_url 
    end
  end
  
  def show
    #ID aus Request
    @id = params[:id].to_i
    #Schritt aus Topic Map holen    
    @user = @tm.topic_by_id(@id)
    
    if (@tm.get(topicType).instances.include?(@user))
      @labels = @user.counterplayers(:atype => @base_locator+"/association/scoping")
      @acc_members = @tm.get(@base_locator+"/association/membership")
      @usergroups = @user.counterplayers(:atype => @base_locator+"/association/membership", :rtype => @base_locator+"/role/member")
    else
      redirect_to users_url 
    end
  end  
  
end
