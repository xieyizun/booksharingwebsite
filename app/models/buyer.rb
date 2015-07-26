class Buyer < ActiveRecord::Base
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password

	before_save { |user| user.email = email.downcase }
	before_save :create_remember_token
	#验证姓名,邮件,密码的格式以及正确性
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\_.]+@[a-z\d\_.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
				uniqueness: {case_sensitive: false}
	validates :password, presence: true, length: {minimum: 6}
	validates :password_confirmation, presence: true
	#一个用户拥有许多书籍,书单,评分
	has_many :products, dependent: :destroy
	has_many :orders, dependent: :destroy
	has_many :comments, dependent: :destroy
	
	private 
		#创建cokie,用于记住用户
		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
