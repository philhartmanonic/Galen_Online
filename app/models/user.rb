class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role
  has_many :posts

  def role?(type)
  	if self.role.nil?
  		false
  	else	
	  	self.role.name == type
	end
  end
end
