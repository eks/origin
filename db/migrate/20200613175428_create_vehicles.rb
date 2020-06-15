class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles do |t|
      t.integer :year, default: 2000
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
