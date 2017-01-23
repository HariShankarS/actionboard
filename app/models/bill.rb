class Bill < ActiveRecord::Base
  has_many :collections
  validates_uniqueness_of :reference

  def total_collection
  	collections.collect(&:amount).inject(:+).to_i
  end

  def balance_due
  	amount.to_i-total_collection
  end
end
