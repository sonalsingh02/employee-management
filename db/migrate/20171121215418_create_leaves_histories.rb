class CreateLeavesHistories < ActiveRecord::Migration[5.1]
  def change
  	create_table :leaves_histories do |t|
  		t.date :start_date
			t.date :end_date
			t.integer :status
			t.integer :leaves_taken
			t.references :employee
			t.timestamps
    end
  end
end
