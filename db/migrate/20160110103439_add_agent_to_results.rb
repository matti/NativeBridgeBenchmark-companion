class AddAgentToResults < ActiveRecord::Migration
  def change
    add_column :results, :agent, :string
  end
end
