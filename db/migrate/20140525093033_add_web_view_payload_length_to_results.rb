class AddWebViewPayloadLengthToResults < ActiveRecord::Migration
  def change
    add_column :results, :webview_payload_length, :integer
  end
end
