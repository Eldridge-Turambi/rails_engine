require 'rails_helper'

RSpec.describe 'Items API' do

  it 'sends a list of items' do
    merchant1 = Merchant.create!(name: "merchant1")
    item1 = merchant1.items.create!(name: 'name1', description: 'description1', unit_price: 100.0 )
    item2 = merchant1.items.create!(name: 'name2', description: 'description2', unit_price: 200.0 )
    item3 = merchant1.items.create!(name: 'name3', description: 'description3', unit_price: 300.0 )

    get '/api/v1/items'

    expect(response).to be_successful

    items_parsed = JSON.parse(response.body, symbolize_names: true)
    expect(items_parsed[:data].count).to eq(3)

    items_parsed[:data].each do |item|
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
end
