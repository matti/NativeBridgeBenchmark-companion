
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

# must use http
window.sendWithXHR = (opts={}) ->
  xhr = new XMLHttpRequest()
  xhr.open "get", "http://#{generateRequestURL(opts)}", opts.async
  xhr.send()

window.sendWithAClick = (opts={}) ->
  aElem = document.createElement("a")
  aElem.href = generateRequestURL(opts)
  aElem.click()

window.sendWithHtmlIframe = (opts={}) ->
  iframeElem = document.createElement("iframe")
  iframeElem.src = generateRequestURL(opts)
  document.body.appendChild(iframeElem)

window.sendWithHtmlIframeSame = (opts={}) ->
  iframeElem = document.querySelector("iframe#sender")
  iframeElem.src = generateRequestURL(opts)

window.sendWithJSCoreSync = (opts={}) ->
  requestUrl = generateRequestURL(opts)
  window.viewController.nativeBridge(requestUrl)

window.sendWithWebSockets = (opts={}) ->
  window.WebSocketTest2(generateRequestURL(opts))

window.sendWithCookie = (opts={}) ->
  document.cookie = "nativebridge=#{generateRequestURL(opts)}"

window.sendWithHtmlObject = (opts={}) ->
  objectElem = document.createElement("object")
  objectElem.data = generateRequestURL(opts)
  document.body.appendChild(objectElem)

window.sendWithHtmlEmbed = (opts={}) ->
  embedElem = document.createElement("embed")
  embedElem.src = generateRequestURL(opts)
  document.body.appendChild(embedElem)

# must use http
window.sendWithHtmlLink = (opts={}) ->
  linkElem = document.createElement("link")
  linkElem.href = "http://#{generateRequestURL(opts)}"
  linkElem.rel = "stylesheet"
  linkElem.type = "text/css"

  document.body.appendChild(linkElem)

window.sendWithHtmlImg = (opts={}) ->
  imgElem = document.createElement("img")
  imgElem.src = "http://#{generateRequestURL(opts)}"

  document.body.appendChild(imgElem)

window.sendWithHtmlSvgImage = (opts={}) ->
  svgElem = document.createElementNS 'http://www.w3.org/2000/svg', 'svg'
  svgElem.width = "100px"
  svgElem.height = "100px"
  svgElem.xmlns = "http://www.w3.org/2000/svg"

  svgImageElem = document.createElementNS 'http://www.w3.org/2000/svg', 'image'
  svgImageElem.setAttributeNS 'http://www.w3.org/1999/xlink','href', "http://#{generateRequestURL(opts)}"

  svgElem.appendChild(svgImageElem)

  document.body.appendChild(svgElem)

#must use http
window.sendWithHtmlScript = (opts={}) ->
  scriptElem = document.createElement("script")
  scriptElem.src = "http://#{generateRequestURL(opts)}"

  document.body.appendChild(scriptElem)

window.sendWithLocalStorage = (opts={}) ->
  localStorage.setItem("nativebridge#{opts.currentMessageIndex}", generateRequestURL(opts))

window.intervalSender = (opts={}) ->

  messagesLeft = opts.messagesLeft || opts.messages
  messagesLeft = messagesLeft - 1

  # TODO: check that works also:

  currentFps = parseInt(stats.domElement.firstChild.textContent)

  if window.COULD_NOT_ANIMATE_EVEN_ONCE
    currentFps = 0
  else
    window.COULD_NOT_ANIMATE_EVEN_ONCE = true

  window.renderloopHighest = 0

  setTimeout =>
    currentMessageIndex = opts.messages - messagesLeft
    window.showIndicator "Sending message #{currentMessageIndex}/#{opts.messages}"

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
    else if opts.method == "html.iframe"
      sendWithHtmlIframe
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "html.iframe.same"
      sendWithHtmlIframeSame
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "xhr.sync"
      sendWithXHR
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
        async: false
    else if opts.method == "xhr.async"
      sendWithXHR
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
        async: true
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
    else if opts.method == "html.object"
      sendWithHtmlObject
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "html.embed"
      sendWithHtmlEmbed
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "html.link"
      sendWithHtmlLink
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "html.img"
      sendWithHtmlImg
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "html.svgImage"
      sendWithHtmlSvgImage
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "html.script"
      sendWithHtmlScript
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
    else if opts.method == "localStorage"
      sendWithLocalStorage
        payload: opts.payload
        method: opts.method
        currentFps: currentFps
        currentMessageIndex: currentMessageIndex

    if messagesLeft > 0
      betterOpts = opts
      betterOpts.messagesLeft = messagesLeft
      window.intervalSender(betterOpts)
    else
      window.showIndicator "DONE", 750


      if getParameterByName("method")
        nextTestId = parseInt(getParameterByName("next_test_id"))

        window.showIndicator "waiting 5s..", 750

        # TODO: might prevent weirdbug (101 vs 99)
        window.setTimeout =>
          window.location = "/tests/#{nextTestId}/perform"
        , 5000

      #   window.location.reload()
      # , 1000

  , opts.interval

window.renderloopElem = document.querySelector("#renderloop");

window.setInterval ->
  now = Date.now()

  delta = now - window.renderloopLast
  window.renderloopHighest = delta unless window.renderloopHighest

  if delta > window.renderloopHighest
    window.renderloopHighest = delta

  window.renderloopElem.textContent = delta + " " + window.renderloopHighest

  window.renderloopLast = now
, 100

window.getParameterByName = (name) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  if results
    decodeURIComponent(results[1].replace(/\+/g, " "))
  else
    null


document.querySelector("button#perform").onclick = ->
  method = getParameterByName('method') || document.querySelector("#methodElem").value
  interval = parseInt(getParameterByName('interval') || document.querySelector("#intervalLengthElem").value)
  messages = parseInt(getParameterByName('amount') || document.querySelector("#messagesElem").value)

  payloadLength = parseInt(getParameterByName('payload') || document.querySelector("#payloadLengthElem").value)

  showIndicator("generating payload...")
  window.setTimeout =>
    payload = window.payloadGenerator(1024*payloadLength)

    #eliminate touch event fuckup
    window.setTimeout =>
      showIndicator("started #{method} (every #{interval}ms) with #{payloadLength} of payload")
      intervalSender
        method: method
        interval: interval
        messages: messages
        payload: payload
    , 1000
  , 500

if getParameterByName("method")
  document.querySelector("button#perform").click()

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
