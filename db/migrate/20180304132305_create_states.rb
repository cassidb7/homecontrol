class CreateStates < ActiveRecord::Migration[5.1]
  def change
    create_table :states do |t|
      t.string :on_state
      t.integer :brightness_state
      t.integer :hue_state
      t.integer :saturation_state
      t.string :effect
      t.decimal :x_state
      t.decimal :y_state
      t.integer :ct_state
      t.string :alert

      t.references :light, index: true

      t.timestamps
    end
  end
end
