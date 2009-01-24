# To change this template, choose Tools | Templates
# and open the template in the editor.

class AutocompleteController < ApplicationController
  def initialize
    
  end

  def show
    @part = params[:id]
    @materials = @tm.get(@base_locator + "/types/material").instances
    @result = Hash.new
    i = 0
    for material in @materials
      labels = material.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/displaylabel" )
      for  label in labels
        if label.start_with?(@part)
          @result[label] = label
          i = i + 1
        end
      end
      basename = material["-"].first
      if basename
        if basename.value.start_with?(@part)
          @result[basename.value] = basename.value
          i = i + 1
        end
      else
        defaultlabel = material[@base_locator + "/types/label"].first
        if defaultlabel
          if defaultlabel.value.start_with?(@part)
            @result[defaultlabel.value] = defaultlabel.value
            i = i + 1
          end
        end
      end
    end
    @results = JSON(@result)
    puts "Ergebnis: "+ @results
    #@results[0] = '{'
    #@results[@results.size-1] = '}'   
  end
end
