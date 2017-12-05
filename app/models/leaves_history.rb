class LeavesHistory < ApplicationRecord
	belongs_to :employee
	validates :start_date, presence: true
	validates :end_date, presence: true
	enum status: [:approved, :disapproved, :pending, :cancelled]
end
