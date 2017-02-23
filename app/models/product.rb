class Product < ActiveRecord::Base
	default_scope { order('title') }
	has_many :line_items
	has_many :orders, through: :line_items
	before_destroy :ensure_not_referenced_by_any_line_item
	validates :price, :title, :description, :image_url, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates :title, uniqueness: true
	validates :image_url, format: 
						{
							with: %r{([^\s]+(\.(?i)(jpg|png|gif|bmp))$)},
							message: 'must be a URL ofr GIF, JPG or PNG image.'
						}

	def ensure_not_referenced_by_any_line_item
		if line_items.count.zero?
			return true
		else
			errors.add(:base, 'Line Items present')
			return false
		end
	end
end
