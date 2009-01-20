class LanguageController < ApplicationController
  private
  def topicType
    return @base_locator + "/types/language" 
  end
  
  public
  
  def index
    @languages = @tm.get(topicType).instances
    if (@languages.size < 1)
      redirect_to:controller => "product", :action => "index" 
    end
  end
  
  def show
    @id = params[:id].to_i
    @language = @tm.topic_by_id(@id)
    if (@tm.get(topicType).instances.include?(@language))
    else
      redirect_to:controller => "language", :action => "index"
    end
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
    #Aktuelle Sprache
    @language = @tm.topic_by_id(@id)
    @tm.destroy(@language)
  end
end
