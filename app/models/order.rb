class Order < ActiveRecord::Base
	PAYMENT_TYPES = [ "Cheque", "Credit card", "Purchase order" ]
	validates :name, :address, :email, :pay_type, presence: true
	has_many :line_items, dependent: :destroy
	validates :pay_type, inclusion: PAYMENT_TYPES
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, format: { with: VALID_EMAIL_REGEX }

	def add_line_items_from_cart(cart)
		cart.line_items.each do |item|
			item.cart_id = nil
			line_items << item
		end
	end
end
