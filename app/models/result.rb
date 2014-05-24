class Result < ActiveRecord::Base
  belongs_to :test

  def delta_webview_to_native
    delta = native_received_at.to_f - webview_started_at.to_f
    delta < 0 ? "N/A" : delta

  end

  def delta_native_to_webview
    delta = webview_received_at.to_f - native_started_at.to_f
    delta < 0 ? "N/A" : delta
  end

end
