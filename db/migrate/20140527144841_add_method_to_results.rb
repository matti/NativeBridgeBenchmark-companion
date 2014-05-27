class AddMethodToResults < ActiveRecord::Migration
  def change
    add_column :results, :method_name, :string
  end
end
