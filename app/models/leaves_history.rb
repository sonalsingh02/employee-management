class LeavesHistory < ApplicationRecord
	belongs_to :employee
	enum status: [:approved, :disapproved, :pending, :cancelled]
	validates :start_date, presence: true
	validates :end_date, presence: true
end
