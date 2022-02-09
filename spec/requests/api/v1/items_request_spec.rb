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

  it 'sends one item' do
    merchant1 = Merchant.create!(name: "merchant1")
    item1 = merchant1.items.create!(name: 'name1', description: 'description1', unit_price: 100.0 )
    item2 = merchant1.items.create!(name: 'name2', description: 'description2', unit_price: 200.0 )
    item3 = merchant1.items.create!(name: 'name3', description: 'description3', unit_price: 300.0 )


    get "/api/v1/items/#{item1.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
  end

  it 'can create a new Item' do
    merchant1 = Merchant.create!(name: "merchant1")
    item_params = ({
      name: 'item4',
      description: 'description1',
      unit_price: 400.0,
      merchant_id: merchant1.id
      })
    info_headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: info_headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
  end

  it 'can update an existing item' do
    merchant1 = Merchant.create!(name: "merchant1")
    item1 = merchant1.items.create!(name: 'name1', description: 'description1', unit_price: 100.0 )

    previous_name = Item.last.name
    item_params = { name: 'mango juul pod'}
    info_headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{item1.id}", headers: info_headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: item1.id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('mango juul pod')
  end
end
