class MerchantSerializer
  def self.format_merchants(merchants)
    { data:
        merchants.map do |merch|
          {id: merch.id.to_s,
          type: 'merchant',
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

  def self.format_nil
    {  data: { }
    }
  end

  def self.format_merchants_revenue(merchants)
    {  data:
      merchants.map do |merch|
        {id: merch.id.to_s,
        type: 'merchant_name_revenue',
        attributes: {
          name: merch.name,
          revenue: merch.revenue
          }}
      end
    }
  end

  def self.format_merchant_revenue(merchant)
    {  data:
        {id: merchant.id.to_s,
        type: 'merchant_revenue',
        attributes: {
          revenue: merchant.total_revenue
          }}
    }
  end

  def self.format_merchants_items_sold(merchants)
    {  data:
      merchants.map do |merch|
        {id: merch.id.to_s,
        type: 'merchant_name_revenue',
        attributes: {
          name: merch.name,
          count: merch.items_sold
          }}
      end
    }
  end
end
