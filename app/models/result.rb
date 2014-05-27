class Result < ActiveRecord::Base
  belongs_to :test

  default_scope { order('id DESC') }

  before_create :set_deltas


  def set_deltas

    self.webview_to_native_delta = native_received_at.to_f - webview_started_at.to_f
    self.webview_to_native_delta = -1.0 if native_received_at.nil?

    self.native_to_webview_delta = webview_received_at.to_f - native_started_at.to_f
    self.native_to_webview_delta = -1.0 if webview_received_at.nil?

  end

end
