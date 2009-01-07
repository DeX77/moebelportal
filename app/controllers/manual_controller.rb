class ManualController < ApplicationController
  def index
    @manuals = @tm.get("http://www.uni-leipzig.de/tmp/ikea/types/manual").instances
  end
end
