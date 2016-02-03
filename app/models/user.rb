class User < ActiveRecord::Base
	belongs_to :role
	has_and_belongs_to_many :bands
	has_many :posts

	def role?(type)
		self.role.name == type
	end

	# def admin?
	# 	self.role.name == "Admin"
	# end

	# def blogger?
	# 	self.role.name == "Blogger"
	# end

	# def regular?
	# 	self.role.name == "Regular"
	# end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
