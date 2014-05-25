class AddNativePayloadLengthToResult < ActiveRecord::Migration
  def change
    add_column :results, :native_payload_length, :integer
  end
end
