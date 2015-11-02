class Product < ActiveRecord::Base
	default_scope { order('title') }
	validates :price, :title, :description, :image_url, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates :title, uniqueness: true
	validates :image_url, format: 
						{
							with: %r{([^\s]+(\.(?i)(jpg|png|gif|bmp))$)},
							message: 'must be a URL ofr GIF, JPG or PNG image.'
						}
end
