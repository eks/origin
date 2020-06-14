class CreateScores < ActiveRecord::Migration[6.0]
  def change
    create_table :scores do |t|
      t.integer :life
      t.integer :home
      t.integer :auto
      t.integer :disability
      t.references :risk_profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
