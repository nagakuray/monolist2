class RankingController < ApplicationController
  def have
    ranking = Have.group(:item_id).order('count_item_id desc').count('item_id').keys
    h_ranking = Item.find(ranking).map{ |model| [model.id, model] }.to_h
    @items = ranking.map{ |id| h_ranking[id] }.first(10)
  end

  def want
    ranking = Want.group(:item_id).order('count_item_id desc').count('item_id').keys
    h_ranking = Item.find(ranking).map{ |model| [model.id, model] }.to_h
    @items = ranking.map{ |id| h_ranking[id] }.first(10)
  end
end
