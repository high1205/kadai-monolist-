class RankingsController < ApplicationController
  def want
    @ranking_want_counts = Want.ranking
    @items = Item.find(@ranking_want_counts.keys)
  end
  
  def have
    @ranking_have_counts = Have.ranking
    @items = Item.find(@ranking_have_counts.keys)
  end
  
end