class Profile < ApplicationRecord
	belongs_to :employee
	mount_uploader :image, ImageUploader
end
