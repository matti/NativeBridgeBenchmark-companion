class AddFpsToResult < ActiveRecord::Migration
  def change
    add_column :results, :fps, :integer
  end
end
