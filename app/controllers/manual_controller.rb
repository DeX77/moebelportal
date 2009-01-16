class ManualController < ApplicationController
  def index
    @manuals = @tm.get(@base_locator+"/types/manual").instances
    if (@manuals.size < 1)
      redirect_to:controller => "product", :action => "index" 
    end
    
  end
  
  def show
    #Topic Nummer
    @id = params[:id].to_i
    #Aktuelles Manual
    @manual = @tm.topic_by_id(@id)
    #Alle Assoziationen
    @all_assosciations = @manual.counterplayers
    #Produkt zum Handbuch
    @product = @manual.counterplayers(:atype => @base_locator+"/association/manual_of")
    #Nötige Schritte
    @set_of_steps = @manual.counterplayers(:atype => @base_locator+"/association/set_of_steps")

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
    #Aktuelles Manual
    @manual = @tm.topic_by_id(@id)
    @tm.destroy(@manual)
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
end
