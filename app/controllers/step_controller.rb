class StepController < ApplicationController
  def index
    @steps = @tm.get(@base_locator+"/types/step").instances
  end
  
  def show
    @id = params[:id].to_i
    @step = @tm.topic_by_id(@id)
  end
end
