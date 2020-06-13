class AddAgeDependentsIncomeMaritalStatusRiskQuestionsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :age, :integer
    add_column :users, :dependents, :integer
    add_column :users, :income, :decimal, precision: 10, scale: 2
    add_column :users, :marital_status, :string
    add_column :users, :risk_questions, :string
  end
end
