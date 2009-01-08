class ManualController < ApplicationController
  def index
    @manuals = @tm.get(@base_locator+"/types/manual").instances
  end
  
  def show
    @id = params[:id].to_i
    @manual = @tm.topic_by_id(@id)
    @product = @manual.counterplayers(:atype => @base_locator+"/association/manual_of")
    @set_of_steps = @manual.counterplayers(:atype => @base_locator+"/association/set_of_steps")
  end
end
