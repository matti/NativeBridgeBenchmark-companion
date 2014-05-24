class Result < ActiveRecord::Base
  belongs_to :test

  def delta_webview_to_native
    native_received_at.to_f - webview_started_at.to_f
  end

  def delta_native_to_webview
    webview_received_at.to_f - native_started_at.to_f
  end

end
