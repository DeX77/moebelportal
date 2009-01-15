class ManualController < ApplicationController
  def index
    @manuals = @tm.get(@base_locator+"/types/manual").instances
  end
  
  def show
    #Topic Nummer
    @id = params[:id].to_i
    #Aktuelles Manual
    @manual = @tm.topic_by_id(@id)
    #Alle Assoziationen
    @all_assosciations = @manual.counterplayers()
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
  
end
