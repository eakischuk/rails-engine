class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.search_by_name(name)
    where("name ILIKE ?", "%#{name}%")
    .order(name: :asc)
  end
end
