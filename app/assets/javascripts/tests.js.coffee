
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

window.showIndicator = (message, delay=0) ->

  if delay > 0
    setTimeout ->
      showIndicator(message)
    , delay
    return

  indicatorElem = document.querySelector("#indicator")
  indicatorElem.textContent = message

  if indicatorElem.style.visibility == "visible"
    # extend the timeout by cancelling it first
    window.clearTimeout window.showIndicatorTimeout
  else
    indicatorElem.style.visibility="visible"

  window.showIndicatorTimeout = setTimeout =>
    indicatorElem.style.visibility = "hidden"
  , 1500



window.payloadGenerator = (length) ->
  text = ""
  possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  for i in [0..length] by 1
    text += possible.charAt(Math.floor(Math.random() * possible.length))

  return text


generateRequestURL = (opts={}) ->
  now = new Date
  requestURL = "nativebridge://ping?webview_started_at=#{now.toJSON()}&payload=#{opts.payload}&method_name=#{opts.method}&fps=#{opts.currentFps}"


window.sendWithLocationHref = (opts={}) ->
  window.location.href=generateRequestURL(opts)

window.sendWithLocationHash = (opts={}) ->
  window.location.hash=generateRequestURL(opts)

window.sendWithXHRSync = (opts={}) ->
  xhr = new XMLHttpRequest()
  xhr.open "get", "http://#{generateRequestURL(opts)}", true
  xhr.send()


window.sendWithAClick = (opts={}) ->
  aElem = document.createElement("a")
  aElem.href = generateRequestURL(opts)
  aElem.click()

window.sendWithIFrame = (opts={}) ->
  iframeElem = document.createElement("iframe")
  iframeElem.src = generateRequestURL(opts)
  document.body.appendChild(iframeElem)

window.sendWithJSCoreSync = (opts={}) ->
  window.viewController.nativeBridge(generateRequestURL(opts))

window.sendWithWebSockets = (opts={}) ->
  window.WebSocketTest2(generateRequestURL(opts))

window.sendWithCookie = (opts={}) ->
  document.cookie = "nativebridge=#{generateRequestURL(opts)}"

window.intervalSender = (opts={}) ->

  messagesLeft = opts.messagesLeft || opts.messages
  messagesLeft = messagesLeft - 1

  # TODO: check that works also:

  currentFps = parseInt(stats.domElement.firstChild.textContent)

  if window.COULD_NOT_ANIMATE_EVEN_ONCE
    currentFps = 0
  else
    window.COULD_NOT_ANIMATE_EVEN_ONCE = true

  setTimeout =>
    window.showIndicator "Sending message #{opts.messages - messagesLeft}/#{opts.messages}"

    if opts.method == "location.href"
      sendWithLocationHref
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "location.hash"
      sendWithLocationHash
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "a.click"
      sendWithAClick
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "iframe.src"
      sendWithIFrame
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "xhr.sync"
      sendWithXHRSync
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "jscore.sync"
      sendWithJSCoreSync
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "http.websockets"
      sendWithWebSockets
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "cookie"
      sendWithCookie
        payload: opts.payload
        method: opts.method
        currentFps: currentFps

    if messagesLeft > 0
      betterOpts = opts
      betterOpts.messagesLeft = messagesLeft
      window.intervalSender(betterOpts)
    else
      window.showIndicator "DONE", 750

  , opts.interval


document.querySelector("button#perform").onclick = ->

  method = document.querySelector("#methodElem").value
  interval = parseInt(document.querySelector("#intervalLengthElem").value)
  messages = parseInt(document.querySelector("#messagesElem").value)

  payloadLength = parseInt(document.querySelector("#payloadLengthElem").value)

  payload = window.payloadGenerator(1024*payloadLength)

  showIndicator("started #{method} (every #{interval}ms) with #{payloadLength} of payload")

  intervalSender
    method: method
    interval: interval
    messages: messages
    payload: payload


###
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

  if window.loadURLSending
    performLocationHref()
###
