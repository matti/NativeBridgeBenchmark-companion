# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener "DOMContentLoaded", ->

  loadURLElem = document.querySelector("button#loadURL")

  if loadURLElem
    loadURLElem.onclick = ->
      console.log "loadURL started"
      now = new Date

      window.location.href="nativeBridge://ping?webview_started_at=#{now.toJSON()}&pong=pong"

      indicatorElem = document.querySelector("#indicator")
      indicatorElem.textContent = "performed"
      indicatorElem.style.visibility="visible"

      setTimeout =>
        indicatorElem.style.visibility = "hidden"
      , 500

window.pong = (fromNativeJSON) ->
  fromNative = JSON.parse(fromNativeJSON).result
  now = new Date

  $.ajax
    type: 'POST'
    data:
      result:
        webview_started_at: fromNative.webview_started_at
        webview_received_at: now.toJSON()
        native_received_at: fromNative.native_received_at
        native_started_at: fromNative.native_started_at
    success: (data) ->
      console.log "put suges"
