# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.addEventListener "DOMContentLoaded", ->

  document.querySelector("button#loadURL").onclick = ->
    console.log "loadURL started"
    now = new Date

    window.location.href="nativeBridge://ping?webview_started_at=#{now.toJSON()}"

    indicatorElem = document.querySelector("#indicator")
    indicatorElem.textContent = "performed"
    indicatorElem.style.visibility="visible"

    setTimeout =>
      indicatorElem.style.visibility = "hidden"
    , 500