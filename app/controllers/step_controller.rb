class StepController < ApplicationController
  def index
    @steps = @tm.get("http://www.uni-leipzig.de/tmp/ikea/types/step").instances
  end
end
