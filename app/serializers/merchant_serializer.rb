class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  ## I might need this?? hmm
  # has_many :merchants
end
