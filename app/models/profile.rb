class Profile < ApplicationRecord
	belongs_to :employee
	validates :first_name, presence: true
	validates :last_name, presence: true
	validates :email, presence: true
	validates :designation, presence: true
	validates :date_of_birth, presence: true
	validates :date_of_joining, presence: true
	validates :image, presence: true
	validates :image_cache, presence: true
	mount_uploader :image, ImageUploader
end
