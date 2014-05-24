class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :test, index: true

      t.datetime :webview_started_at
      t.datetime :webview_received_at

      t.datetime :native_received_at
      t.datetime :native_started_at

      t.timestamps
    end
  end
end
