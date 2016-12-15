class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    if params[:item_code]
      @item = Item.find_or_initialize_by(item_code: params[:item_code])
    else
      @item = Item.find(params[:item_id])
    end
    
    # itemsテーブルに存在しない場合は楽天のデータを登録する。
    if @item.new_record?
      
      # TODO 商品情報の取得 ::Ichiba:RakutenWebService:Item.search を用いてください
      items = RakutenWebService::Ichiba::Item.search(itemCode: @item.item_code)

      item                  = items.first
      @item.title           = item['itemName']
      @item.small_image     = item['smallImageUrls'].first['imageUrl']
      @item.medium_image    = item['mediumImageUrls'].first['imageUrl']
      @item.large_image     = item['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')
      @item.detail_page_url = item['itemUrl']
      @item.save!
    end

    # TODO ユーザにwant or haveを設定する
    # params[:type]の値にHaveボタンが押された時には「Have」,
    # Wantボタンが押された時には「Want」が設定されています。
    
    if params[:type] == "Have"
      unless current_user.have?(@item)
        current_user.have(@item)
      end
    end
    
    if params[:type] == "Want"
      unless current_user.want?(@item)
        current_user.want(@item)
      end
    end
    
  end

  def destroy
    @item = Item.find(params[:item_id])
    
    # TODO 紐付けの解除。 
    # params[:type]の値にHave itボタンが押された時には「Have」,
    # Want itボタンが押された時には「Want」が設定されています。
    
    if params[:type] == "Have"
      if current_user.have?(@item)
        current_user.unhave(@item)
      end
    end
    
    if params[:type] == "Want"
      if current_user.want?(@item)
        current_user.unwant(@item)
      end
    end
    
  end
end
