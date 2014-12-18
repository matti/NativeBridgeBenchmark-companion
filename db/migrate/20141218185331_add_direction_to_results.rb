class AddDirectionToResults < ActiveRecord::Migration
  def change
    add_column :results, :direction, :string
  end
end
