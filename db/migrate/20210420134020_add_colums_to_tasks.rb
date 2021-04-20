class AddColumsToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :user, :string
    add_column :tasks, :priority, :string
    add_column :tasks, :end_date, :date
  end
end
