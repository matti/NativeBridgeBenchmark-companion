class AddCpuAndMemToResults < ActiveRecord::Migration
  def change
    add_column :results, :cpu, :float
    add_column :results, :mem, :float
  end
end
