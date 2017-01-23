json.extract! bill, :id, :invoice_date, :customer_name, :brand_manager, :narration, :amount, :reference, :created_at, :updated_at
json.url bill_url(bill, format: :json)