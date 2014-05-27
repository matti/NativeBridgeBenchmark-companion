class AddDeltasToResults < ActiveRecord::Migration
  def change
    add_column :results, :webview_to_native_delta, :float
    add_column :results, :native_to_webview_delta, :float
  end
end
