class CreateLights < ActiveRecord::Migration[5.1]
  def change
    create_table :lights do |t|
      t.integer :light_identifier
      t.string :uniqueid

      t.timestamps
    end
  end
end
