class CreateProfiles < ActiveRecord::Migration[5.1]
	def change
		create_table :profiles do |t|
			t.string :first_name
			t.string :last_name
			t.string :designation
			t.date :date_of_birth
			t.date :date_of_joining
			t.string :email
			t.references :employee
			t.timestamps
		end
	end
end
