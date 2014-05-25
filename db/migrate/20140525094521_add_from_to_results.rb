class AddFromToResults < ActiveRecord::Migration
  def change
    add_column :results, :from, :string
  end
end
