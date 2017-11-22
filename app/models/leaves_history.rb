class LeavesHistory < ApplicationRecord
	belongs_to :employee
	enum status: [:approved, :disapproved, :pending, :cancelled]
end
