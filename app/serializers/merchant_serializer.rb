class MerchantSerializer
  def self.format_merchants(merchants)
    { data:
        merchants.map do |merch|
          {id: merch.id,
          attributes: {
            name: merch.name
            }}
        end
  }
  end

  def self.format_merchant(merchant)
    {  data: {
        id: merchant.id.to_s,
        type: "merchant",
        attributes: {
          name: merchant.name
         }
      }}
  end
end
