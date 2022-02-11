require 'rails_helper'

RSpec.describe 'Merchants API' do

  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)
    merchants_data = merchants[:data]

    merchants_data.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get json for one merchant (show)' do
    merchant_id = create(:merchant).id

    get "/api/v1/merchants/#{merchant_id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data]).to have_key(:id)
    ## How to change below to integer
    expect(merchant[:data][:id]).to eq(merchant_id.to_s)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'can send all items for a given merchant ID' do
    merchant1 = Merchant.create!(name: "merchant1")
    merchant2 = Merchant.create!(name: "merchant2")
    item1 = merchant1.items.create!(name: 'name1', description: 'description1', unit_price: 100.0 )
    item2 = merchant1.items.create!(name: 'name2', description: 'description2', unit_price: 200.0 )
    item3 = merchant2.items.create!(name: 'name3', description: 'description3', unit_price: 300.0 )

    # merchant1 = create(:merchant)
    # merchant2 = create(:merchant)

    get "/api/v1/merchants/#{merchant1.id}/items"

    parsed_merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    parsed_merchant[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it 'finds one merchants which match a search term' do
    merchant1 = Merchant.create!(name: "james flex")
    merchant2 = Merchant.create!(name: "renata flex")
    merchant3 = Merchant.create!(name: "reggie thomas")
    merchant4 = Merchant.create!(name: "juul pod")

    get "/api/v1/merchants/find?name=flex"

    expect(response).to be_successful


    parsed_merchants = JSON.parse(response.body, symbolize_names: true)
    expect(parsed_merchants[:data][:attributes][:name]).to eq(merchant1.name)
  end
end
