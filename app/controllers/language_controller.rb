class LanguageController < ApplicationController
  def index
    @languages = @tm.get(@base_locator+"/types/language").instances
  end
  
  def show
    @id = params[:id].to_i
    @language = @tm.topic_by_id(@id)
  end
end
