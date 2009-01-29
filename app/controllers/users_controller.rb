class UsersController < ApplicationController
  
    before_filter :authorize_admin, :except => [:show, :index, :login, :validate_login]
    
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
 
  def login
    
  end
  
  def logout
    flash[:notice] = "Logged out"
    reset_session
    redirect_to root_url
  end
  
  def validate_login
    entered_username = params[:login]
    entered_password = params[:pwd].first
    
    puts "Nutzer: " + entered_username
    userTopic = ""
    @tm.get(topicType).instances.each() do |topic|
      if (get_default_label(topic).include? entered_username)
        userTopic = topic
        break
      end
    end
    
    userPwd = userTopic[@base_locator+"/types"].first.value
    
    if (userPwd == entered_password)
      flash[:notice] = "Logged in"
      session[:user] = entered_username
      redirect_to root_url
    else
      flash[:error] = "Poeser Pursche!!"
      puts "Password: " + entered_password
      puts " sollte sein: " + userPwd
      redirect_to login_url
    end
  end
  
  def membership    
    #ID aus Request
    @id = params[:id].to_i
    #Schritt aus Topic Map holen
    @user = @tm.topic_by_id(@id)
    @association = @tm.get(@base_locator+"/association/membership")
    @hash = Hash.new
    if (@tm.get(topicType).instances.include?(@user))
          @usergroup = @tm.get(@base_locator + "/types/usergroup").instances
          for group in @usergroup
            @hash[get_label(group)] = group.id
          end
    else
      redirect_to root_url
    end
  end

  def set_usergroup
    #ID aus Request
    @id = params[:id].to_i
    #Schritt aus Topic Map holen
    @user = @tm.topic_by_id(@id)
    @group = params[:group_id].to_i
    @usergroup = @tm.topic_by_id(@id)
    create_association(@base_locator+"/association/membership",@user,@base_locator+"/role/member",@usergroup,@base_locator+"/role/group")
    redirect_to(users_url(@id))
  end
end
