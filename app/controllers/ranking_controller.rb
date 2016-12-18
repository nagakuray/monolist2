class RankingController < ApplicationController
  def have
    ranking = Have.group(:item_id).order('count_item_id desc').count('item_id').keys
    h_ranking = Item.find(ranking).map{ |model| [model.id, model] }.to_h
    @items = ranking.map{ |id| h_ranking[id] }.first(10)
    
    # 別の書き方    
    # item_ids = Have.group(:item_id).order('count_item_id desc').limit(10).count('item_id').keys
    # @items = Item.find(item_ids).sort_by{|item| item_ids.index(item.id)}
  end

  def want
    ranking = Want.group(:item_id).order('count_item_id desc').count('item_id').keys
    h_ranking = Item.find(ranking).map{ |model| [model.id, model] }.to_h
    @items = ranking.map{ |id| h_ranking[id] }.first(10)
  end
end
