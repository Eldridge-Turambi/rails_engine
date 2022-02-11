class Api::V1::SearchesController < ApplicationController

  def find_one_merchant
    merchant = Merchant.where("name ILIKE ?","%#{params[:name]}%").first
    if merchant.nil?
      render json: { data: { message: 'Merchant not found' } }
    else
      render json: MerchantSerializer.new(merchant)
    end
  end

  def find_all_items
    found_items = Item.where("name ILIKE ?", "%#{params[:name]}%")
    render json: ItemSerializer.new(found_items)
  end
end
