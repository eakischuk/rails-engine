class RevenueSerializer
  def self.format_date_range_revenue(revenue)
    {
      data: {
        id: nil,
        type: 'revenue',
        attributes: {
          revenue: revenue
        }
      }
    }
  end
end
