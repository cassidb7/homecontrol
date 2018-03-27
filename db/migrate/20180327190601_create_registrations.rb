class CreateRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :registrations do |t|
      t.string :number
      t.string :owner
      t.integer :reg_length

      t.timestamps
    end
  end
end
