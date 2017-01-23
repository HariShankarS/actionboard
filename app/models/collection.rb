class Collection < ActiveRecord::Base
  belongs_to :bill
  validate :allowed_reference, :allowed_amount
  validates_presence_of :amount, :collection_date, :bill_id

  def allowed_reference
  	unless reference == bill.reference
  	  errors.add(:reference, "is not matching with the bill's reference")
  	end
  end

  def allowed_amount
  	unless amount.to_i <=  bill.balance_due
  	  errors.add(:amount, "is greater than the bill's balance due")
  	end
  end
end
