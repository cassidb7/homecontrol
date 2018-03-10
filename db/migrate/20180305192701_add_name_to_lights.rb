class AddNameToLights < ActiveRecord::Migration[5.1]
  def change
    add_column :lights, :name, :string, limit: 100
  end
end
