class CreateConfigSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :config_settings do |t|
      t.string :title
      t.string :setting

      t.timestamps
    end
  end
end
