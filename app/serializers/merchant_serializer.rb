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
end
