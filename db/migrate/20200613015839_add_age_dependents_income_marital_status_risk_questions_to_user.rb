class AddAgeDependentsIncomeMaritalStatusRiskQuestionsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :age, :integer, default: 0
    add_column :users, :dependents, :integer, default: 0
    add_column :users, :income, :decimal, precision: 10, scale: 2, default: 0
    add_column :users, :marital_status, :string, default: 'single'
    add_column :users, :risk_questions, :string, default: [0,0,0].to_yaml
  end
end
