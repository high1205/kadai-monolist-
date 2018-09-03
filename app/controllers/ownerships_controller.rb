class OwnershipsController < ApplicationController
  def create
    @item = Item.find_or_initialize_by(code: params[:item_code])

    unless @item.persisted?
      # @item が保存されていない場合、先に @item を保存する
      results = RakutenWebService::Ichiba::Item.search(itemCode: @item.code)

      @item = Item.new(read(results.first))
      @item.save
    end

    # Want 関係として保存
    if params[:type] == 'Want'
      current_user.want(@item)
      flash[:success] = '商品を希望リストに入れました。'
    end
    
    # Have 関係として保存
    if params[:type] == 'Have'
      current_user.have(@item)
      flash[:success] = '商品を既保有リスト入れました。'
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])
    
    # Want 関係から解除
    if params[:type] == 'Want'
      current_user.unwant(@item) 
      flash[:danger] = '商品を希望リストから削除しました。'
    end
    
    # Have 関係から解除
    if params[:type] == 'Have'
      current_user.unhave(@item) 
      flash[:danger] = '商品を既保有リストから削除しました。'
    end

    redirect_back(fallback_location: root_path)
  end
end