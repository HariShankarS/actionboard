class Bill < ActiveRecord::Base
  has_many :collections
  validates_uniqueness_of :reference

  def total_collection
  	Bill.joins(:collections).where("bills.id=#{id}").sum("collections.amount")
  end

  def balance_due
    amount.to_i-total_collection
  end
end
