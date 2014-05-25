# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

document.body.ontouchmove = (e) ->
  if window.CANT_TOUCH_THIS
    e.preventDefault()

document.querySelector("button#toggleScrolling").onclick = ->

  if window.CANT_TOUCH_THIS
    showIndicator("scroll enabled")
    window.CANT_TOUCH_THIS = false
  else
    showIndicator("scroll prevented")
    window.CANT_TOUCH_THIS = true



window.stats = new Stats
stats.setMode(0) # 0: fps, 1: ms

stats.domElement.style.position = 'fixed'
stats.domElement.style.right = '0px'
stats.domElement.style.top = '0px'

document.body.appendChild( stats.domElement )


window.loadURLThing = () ->
  now = new Date
  console.log "loadURL started"
  window.location.href="nativeBridge://ping?webview_started_at=#{now.toJSON()}&pong=pong"


window.showIndicator = (message) ->
  indicatorElem = document.querySelector("#indicator")
  indicatorElem.textContent = message
  indicatorElem.style.visibility="visible"

  setTimeout =>
    indicatorElem.style.visibility = "hidden"
  , 500



document.querySelector("button#loadURL").onclick = ->

  if window.loadURLInterval
    showIndicator("stopped!")
    clearInterval(window.loadURLInterval)
    delete window.loadURLInterval
    return

  window.loadURLInterval = setInterval =>
    loadURLThing()
  , 250

  showIndicator("started!")


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
