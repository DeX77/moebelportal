class LanguageController < ApplicationController
  def index
    @languages = @tm.get(@base_locator+"/types/language").instances
    if (@languages.size < 1)
      redirect_to:controller => "product", :action => "index" 
    end
  end
  
  def show
    @id = params[:id].to_i
    @language = @tm.topic_by_id(@id)
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
    #Aktuelle Sprache
    @language = @tm.topic_by_id(@id)
    @tm.destroy(@language)
  end
end
