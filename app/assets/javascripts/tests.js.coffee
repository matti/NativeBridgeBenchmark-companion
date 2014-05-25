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

window.payloadGenerator = (length) ->
  text = ""
  possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  for i in [0..length] by 1
    text += possible.charAt(Math.floor(Math.random() * possible.length))

  return text

window.loadURLThing = (payload, pongBack, pongPayloadLength) ->
  now = new Date
  console.log "loadURL started"
  requestURL = "nativeBridge://ping?webview_started_at=#{now.toJSON()}&payload='#{payload}'"

  if pongBack
    requestURL = requestURL + "&pong=pong&pongPayloadLength=#{pongPayloadLength}"

  window.location.href=requestURL


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

  payloadLength = parseInt(document.querySelector("#payloadLengthElem").value)
  intervalLength = parseInt(document.querySelector("#intervalElem").value)
  pongBack = document.querySelector("#pongElem").value == "yes"
  pongPayloadLength = parseInt(document.querySelector("#pongPayloadLengthElem").value)

  payload = window.payloadGenerator(1024*payloadLength)

  window.loadURLInterval = setInterval =>
    loadURLThing(payload, pongBack, (pongPayloadLength*1024))
  , intervalLength

  showIndicator("started!")


window.pong = (fromNativeJSON) ->
  fromNative = JSON.parse(fromNativeJSON)
  now = new Date

  currentFps = parseInt(stats.domElement.firstChild.textContent)

  if window.COULD_NOT_ANIMATE_EVEN_ONCE
    currentFps = 0
  else
    window.COULD_NOT_ANIMATE_EVEN_ONCE = true

  $.ajax
    type: 'POST'
    data:
      result:
        webview_started_at: fromNative.webview_started_at
        webview_received_at: now.toJSON()
        native_received_at: fromNative.native_received_at
        native_started_at: fromNative.native_started_at
        webview_payload_length: fromNative.webview_payload_length
        native_payload_length: fromNative.pongPayload.length
        from: "webview"
        fps: currentFps
    success: (data) ->
      console.log "put suges"
