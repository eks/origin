class CreateRiskProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :risk_profiles do |t|
      t.string :life
      t.string :home
      t.string :auto
      t.string :disability
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
