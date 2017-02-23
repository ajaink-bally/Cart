require 'digest/sha2'
class User < ActiveRecord::Base
	validates :name, :presence => true, :uniqueness => true
	validates :password, :confirmation => true
	attr_accessor :password_confirmation
	attr_reader   :password
	validates_confirmation_of :password
	validate  :password_must_be_present

	class << self
		def authenticate(name, password) 
			if user = find_by_name(name)
				if user.hashed_password == User.encrypt_password(password, user.salt)
					user
				end
			end
		end

		def encrypt_password(password, salt)
			puts "Inside encrypt_password"
			Digest::SHA2.hexdigest(password + "wibble" + salt)
		end
	end

	def password=(password)
		@password = password
		if password.present?
			puts "Inside password setter"
			self.salt = generate_salt
			self.hashed_password = User.encrypt_password(password, salt)
		end 
	end

	private

		def password_must_be_present
			errors.add(:password, "Missing password") unless self.hashed_password.present?
		end

		def generate_salt
			puts "Inside generate_salt"
			self.salt = self.object_id.to_s + rand.to_s
		end
end
