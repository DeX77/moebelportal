class ManualController < ApplicationController
  def index
    @manuals = @tm.get(@base_locator+"/types/manual").instances
  end
  
  def show
    @id = params[:id].to_i
    @manual = @tm.topic_by_id(@id)
  end
end
