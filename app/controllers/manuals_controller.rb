class ManualsController < ApplicationController
  private
  def topicType
    return @base_locator + "/types/manual" 
  end
  
  public
  
  
  def index
    @manuals = @tm.get(topicType).instances
    if (@manuals.size < 1)
      redirect_to root_url 
    end
    
  end
  
  def show
    #Topic Nummer
    @id = params[:id].to_i
    #Aktuelles Manual
    @manual = @tm.topic_by_id(@id)
    @association = @tm.get( @base_locator+"/association/set_of_steps")
    @association2 = @tm.get( @base_locator+"/association/manual_of")
    if (@tm.get(topicType).instances.include?(@manual))
      #Alle Assoziationen
      @all_assosciations = @manual.counterplayers
      #Produkt zum Handbuch
      @product = @manual.counterplayers(:atype => @base_locator+"/association/manual_of")
      #Nötige Schritte
      @set_of_steps = @manual.counterplayers(:atype => @base_locator+"/association/set_of_steps")
    else
      redirect_to manuals_url
    end
    
  end
  
  def sort_by_order(set_of_steps)
    return set_of_steps.sort() do |a,b|
      if (a ==b)
        0
      else
        aftera = a.counterplayers(:atype => @base_locator+"/association/sequence_of_steps", :otype => "do after")
        aftera.each() do |newA| 
          while (newA.counterplayers(:atype => @base_locator+"/association/sequence_of_steps", :otype => "do after"))
            aftera +=newA.counterplayers(:atype => @base_locator+"/association/sequence_of_steps", :otype => "do after")
            if(aftera.include?(b))
              1
            end
          end
        end        
        -1        
      end
    end
    
  end

  def contains
    @id = params[:id].to_i
    #Aktuelles Manual
    @manual = @tm.topic_by_id(@id)
    @association = @tm.get( @base_locator+"/association/set_of_steps")
    @hash = Hash.new
    if (@tm.get(topicType).instances.include?(@manual))
      @steps = @tm.get(@base_locator + "/types/step").instances
      for step in @steps
        @hash[get_label(step)] = step.id
      end
    end
  end

  def create_contains
     @id = params[:id].to_i
    @step_id = params[:step_id].to_i
    @manual = @tm.topic_by_id(@id)
    @step = @tm.topic_by_id(@step_id)

    create_association(@base_locator+"/association/set_of_steps",@manual,@base_locator+"/types/role_manual",@step,@base_locator+"/types/role_step")
    redirect_to(manual_url(@id))
  end

end
