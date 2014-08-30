class AddRenderPausedToResults < ActiveRecord::Migration
  def change
    add_column :results, :render_paused, :integer
  end
end
