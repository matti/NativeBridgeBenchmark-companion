
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


generateBetterUserAgent = () ->
  encodeURIComponent "#{navigator.userAgent + window.devicePixelRatio}"

generateRequestURL = (opts={}) ->
  now = new Date
  requestURL = "nativebridge://ping?webview_started_at=#{now.toJSON()}&payload=#{opts.payload}&method_name=#{opts.method}&fps=#{opts.currentFps}&render_paused=#{opts.currentRenderLoopPause}&agent=#{generateBetterUserAgent()}"

  return requestURL;

window.sendWithLocationHref = (opts={}) ->
  window.location.href=generateRequestURL(opts)

window.sendWithLocationHash = (opts={}) ->
  window.location.hash=generateRequestURL(opts)

window.sendWithLocationReplaceHash = (opts={}) ->
  window.location.replace("#" + generateRequestURL(opts))

window.sendWithLocationReplace = (opts={}) ->
  window.location.replace(generateRequestURL(opts))

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
  iframeElem = document.querySelector("iframe.nativebridge")
  iframeElem.src = generateRequestURL(opts)

window.sendWithHtmlIframeReplace = (opts={}) ->
  iframeElem = document.querySelector("iframe.nativebridge")

  clonedElem = iframeElem.cloneNode()
  iframeElem.remove()

  clonedElem.src = generateRequestURL(opts)
  document.body.appendChild(clonedElem)

window.sendWithJSCoreSync = (opts={}) ->
  requestUrl = generateRequestURL(opts)
  window.viewController.nativeBridge(requestUrl)

window.sendWithWebkitUsercontent = (opts={}) ->
  requestUrl = generateRequestURL(opts)
  window.webkit.messageHandlers.nativeBridge.postMessage(requestUrl)

window.sendWithWebSockets = (opts={}) ->
  ws.send(generateRequestURL(opts))

window.sendWithCookie = (opts={}) ->
  document.cookie = "nativebridge=#{generateRequestURL(opts)}"

window.sendWithHtmlObject = (opts={}) ->
  objectElem = document.createElement("object")
  objectElem.data = generateRequestURL(opts)
  document.body.appendChild(objectElem)

window.sendWithHtmlObjectSame = (opts={}) ->
  objectElem = document.querySelector("object.nativebridge")
  objectElem.data = generateRequestURL(opts)

window.sendWithHtmlObjectReplace = (opts={}) ->
  objectElem = document.querySelector("object.nativebridge")
  clonedElem = objectElem.cloneNode()

  objectElem.remove()

  clonedElem.data = generateRequestURL(opts)
  document.body.appendChild(clonedElem)

window.sendWithHtmlEmbed = (opts={}) ->
  embedElem = document.createElement("embed")
  embedElem.src = generateRequestURL(opts)
  document.body.appendChild(embedElem)

window.sendWithHtmlEmbedSame = (opts={}) ->
  embedElem = document.querySelector("embed.nativebridge")
  embedElem.src = generateRequestURL(opts)

window.sendWithHtmlEmbedReplace = (opts={}) ->
  embedElem = document.querySelector("embed.nativebridge")
  clonedElem = embedElem.cloneNode()

  embedElem.remove()

  clonedElem.src = generateRequestURL(opts)
  document.body.appendChild(clonedElem)

# must use http
window.sendWithHtmlLink = (opts={}) ->
  linkElem = document.createElement("link")
  linkElem.href = "http://#{generateRequestURL(opts)}"
  linkElem.rel = "stylesheet"
  linkElem.type = "text/css"

  document.body.appendChild(linkElem)

# must use http
window.sendWithHtmlLinkSame = (opts={}) ->
  linkElem = document.querySelector("link.nativebridge")
  linkElem.href = "http://#{generateRequestURL(opts)}"

# must use http
window.sendWithHtmlLinkReplace = (opts={}) ->
  linkElem = document.querySelector("link.nativebridge")
  clonedElem = linkElem.cloneNode()

  linkElem.remove()

  clonedElem.href = "http://#{generateRequestURL(opts)}"
  document.body.appendChild(clonedElem)

window.sendWithHtmlImg = (opts={}) ->
  imgElem = document.createElement("img")
  imgElem.src = "http://#{generateRequestURL(opts)}"

  document.body.appendChild(imgElem)

window.sendWithHtmlImgSame = (opts={}) ->
  imgElem = document.querySelector("img.nativebridge")
  imgElem.src = "http://#{generateRequestURL(opts)}"

window.sendWithHtmlImgReplace = (opts={}) ->
  imgElem = document.querySelector("img.nativebridge")
  clonedElem = imgElem.cloneNode()

  imgElem.remove()
  clonedElem.src = "http://#{generateRequestURL(opts)}"

  document.body.appendChild(clonedElem)

window.sendWithHtmlSvgImage = (opts={}) ->
  window.sendWithHtmlSvgImageSame(opts)

window.sendWithHtmlSvgImageSame = (opts={}) ->
  svgImageElem = document.querySelector("svg image.nativebridge")
  svgImageElem.setAttributeNS 'http://www.w3.org/1999/xlink','href', "http://#{generateRequestURL(opts)}"

window.sendWithHtmlSvgImageFull = (opts={}) ->
  svgElem = document.createElementNS 'http://www.w3.org/2000/svg', 'svg'
  svgElem.width = "100px"
  svgElem.height = "100px"
  svgElem.xmlns = "http://www.w3.org/2000/svg"

  svgImageElem = document.createElementNS 'http://www.w3.org/2000/svg', 'image'
  svgImageElem.setAttributeNS 'http://www.w3.org/1999/xlink','href', "http://#{generateRequestURL(opts)}"

  svgElem.appendChild(svgImageElem)

  document.body.appendChild(svgElem)

window.sendWithHtmlSvgImageReplace = (opts={}) ->
  svgImageElem = document.querySelector("svg image.nativebridge")
  svgElem = svgImageElem.parentElement

  clonedElem = svgImageElem.cloneNode()
  svgImageElem.remove()

  clonedElem.setAttributeNS 'http://www.w3.org/1999/xlink','href', "http://#{generateRequestURL(opts)}"
  svgElem.appendChild(clonedElem)

#must use http
window.sendWithHtmlScript = (opts={}) ->
  scriptElem = document.createElement("script")
  scriptElem.src = "http://#{generateRequestURL(opts)}"

  document.body.appendChild(scriptElem)

#must use http
window.sendWithHtmlScriptSame = (opts={}) ->
  scriptElem = document.querySelector("script.nativebridge")
  scriptElem.src = "http://#{generateRequestURL(opts)}"

#must use http
window.sendWithHtmlScriptReplace = (opts={}) ->
  scriptElem = document.querySelector("script.nativebridge")

  clonedElem = scriptElem.cloneNode()
  scriptElem.remove()

  clonedElem.src = "http://#{generateRequestURL(opts)}"
  document.body.appendChild(clonedElem)

window.sendWithLocalStorage = (opts={}) ->
  localStorage.setItem("nativebridge#{opts.currentMessageIndex}", generateRequestURL(opts))

window.sendWithWebkitAlert = (opts={}) ->
  window.alert(generateRequestURL(opts))

window.sendWithWebkitPrompt = (opts={}) ->
  window.prompt(generateRequestURL(opts))

window.sendWithWebkitConfirm = (opts={}) ->
  window.confirm(generateRequestURL(opts))

window.sendWithWebkitTitle = (opts={}) ->
  document.title = generateRequestURL(opts)

window.sendWithPrompt = (opts={}) ->
  window.prompt(generateRequestURL(opts))

window.sendWithAlert = (opts={}) ->
  window.alert(generateRequestURL(opts))

window.sendWithConfirm = (opts={}) ->
  window.confirm(generateRequestURL(opts))

window.sendWithPromptPongWeb = (opts={}) ->
  messageJSON = window.prompt(generateRequestURL(opts))
  window.bridgeHead(messageJSON)

window.sendWithJSCorePongWeb = (opts={}) ->
  messageJSON = window.viewController.nativeBridgePong(generateRequestURL(opts))
  window.bridgeHead messageJSON

window.sendWithXHRPongWeb = (opts={}) ->
  xhr = new XMLHttpRequest()
  xhr.open "get", "http://#{generateRequestURL(opts)}", false
  xhr.send()
  window.bridgeHead xhr.responseText

window.sendWithXHRGet = (opts={}) ->
  xhr = new XMLHttpRequest()
  xhr.open "get", "http://localhost:31337/#{generateRequestURL(opts)}", opts.async
  xhr.send()

sendWithXHRPost = (opts={}) ->
  payload = opts.payload
  opts.payload = ""

  xhr = new XMLHttpRequest()
  xhr.open "POST", "http://localhost:31337/#{generateRequestURL(opts)}", opts.async
  xhr.send(payload)

window.currentFps = ->
  fps = if window.COULD_NOT_ANIMATE_EVEN_ONCE
    currentFps = 0
  else
    window.COULD_NOT_ANIMATE_EVEN_ONCE = true
    parseInt(stats.domElement.firstChild.textContent)

  return fps


window.intervalSender = (opts={}) ->

  messagesLeft = opts.messagesLeft || opts.messages
  messagesLeft = messagesLeft - 1

  nativeOptions =
    payload: opts.payload
    method: opts.method
    currentFps: currentFps()
    currentRenderLoopPause: window.renderloopElem.textContent

  setTimeout =>
    currentMessageIndex = opts.messages - messagesLeft
    window.showIndicator "Sending message #{currentMessageIndex}/#{opts.messages}"

    if opts.method == "location.href"
      sendWithLocationHref nativeOptions
    else if opts.method == "location.hash"
      sendWithLocationHash nativeOptions
    else if opts.method == "location.replace"
      sendWithLocationReplace nativeOptions
    else if opts.method == "location.replaceHash"
      sendWithLocationReplaceHash nativeOptions
    else if opts.method == "a.click"
      sendWithAClick nativeOptions
    else if opts.method == "html.iframe"
      sendWithHtmlIframe nativeOptions
    else if opts.method == "html.iframe.same"
      sendWithHtmlIframeSame nativeOptions
    else if opts.method == "html.iframe.replace"
      sendWithHtmlIframeReplace nativeOptions
    else if opts.method == "xhr.sync"
      nativeOptions.async = false
      sendWithXHR nativeOptions
    else if opts.method == "xhr.async"
      nativeOptions.async = true
      sendWithXHR nativeOptions
    else if opts.method == "jscore.sync"
      sendWithJSCoreSync nativeOptions
    else if opts.method == "webkit.usercontent"
      sendWithWebkitUsercontent nativeOptions
    else if opts.method == "http.websockets"
      sendWithWebSockets nativeOptions
    else if opts.method == "cookie"
      sendWithCookie nativeOptions
    else if opts.method == "html.object"
      sendWithHtmlObject nativeOptions
    else if opts.method == "html.object.same"
      sendWithHtmlObjectSame nativeOptions
    else if opts.method == "html.object.replace"
      sendWithHtmlObjectReplace nativeOptions
    else if opts.method == "html.embed"
      sendWithHtmlEmbed nativeOptions
    else if opts.method == "html.embed.same"
      sendWithHtmlEmbedSame nativeOptions
    else if opts.method == "html.embed.replace"
      sendWithHtmlEmbedReplace nativeOptions
    else if opts.method == "html.link"
      sendWithHtmlLink nativeOptions
    else if opts.method == "html.link.same"
      sendWithHtmlLinkSame nativeOptions
    else if opts.method == "html.link.replace"
      sendWithHtmlLinkReplace nativeOptions
    else if opts.method == "html.img"
      sendWithHtmlImg nativeOptions
    else if opts.method == "html.img.same"
      sendWithHtmlImgSame nativeOptions
    else if opts.method == "html.img.replace"
      sendWithHtmlImgReplace nativeOptions
    else if opts.method == "html.svgImage"
      sendWithHtmlSvgImage nativeOptions
    else if opts.method == "html.svgImage.same"
      sendWithHtmlSvgImageSame nativeOptions
    else if opts.method == "html.svgImage.replace"
      sendWithHtmlSvgImageReplace nativeOptions
    else if opts.method == "html.script"
      sendWithHtmlScript nativeOptions
    else if opts.method == "html.script.same"
      sendWithHtmlScriptSame nativeOptions
    else if opts.method == "html.script.replace"
      sendWithHtmlScriptReplace nativeOptions
    else if opts.method == "localStorage"
      nativeOptions.currentMessageIndex = currentMessageIndex
      sendWithLocalStorage nativeOptions
    else if opts.method == "webkit.alert"
      sendWithWebkitAlert nativeOptions
    else if opts.method == "webkit.prompt"
      sendWithWebkitPrompt nativeOptions
    else if opts.method == "webkit.confirm"
      sendWithWebkitConfirm nativeOptions
    else if opts.method == "webkit.title"
      sendWithWebkitTitle nativeOptions
    else if opts.method == "prompt"
      sendWithPrompt nativeOptions
    else if opts.method == "alert"
      sendWithAlert nativeOptions
    else if opts.method == "confirm"
      sendWithConfirm nativeOptions
    else if opts.method == "prompt.pongweb"
      sendWithPromptPongWeb nativeOptions
    else if opts.method == "jscore.pongweb"
      sendWithJSCorePongWeb nativeOptions
    else if opts.method == "xhr.pongweb"
      nativeOptions.async = false
      sendWithXHRPongWeb nativeOptions
    else if opts.method == "xhrget.async"
      nativeOptions.async = true
      sendWithXHRGet nativeOptions
    else if opts.method == "xhrget.sync"
      nativeOptions.async = false
      sendWithXHRGet nativeOptions
    else if opts.method == "xhrpost.sync"
      nativeOptions.async = false
      sendWithXHRPost nativeOptions
    else if opts.method == "xhrpost.async"
      nativeOptions.async = true
      sendWithXHRPost nativeOptions

    window.renderloopHighest = 0

    if messagesLeft > 0
      betterOpts = opts
      betterOpts.messagesLeft = messagesLeft
      window.intervalSender(betterOpts)
    else
      window.showIndicator "DONE", 750

      moveOnToTheNextTestIfSet()

  , opts.interval


moveOnToTheNextTestIfSet = (okToMove=false)=>

  if okToMove
    unless window.location.href.match("next_test_id")
      console.log "no next_test_id set, not moving"
      return

    # TODO: might prevent weirdbug (101 vs 99)
    window.setTimeout =>
      nextTestId = parseInt(getParameterByName("next_test_id"))
      window.location = "/tests/#{nextTestId}/perform"
    , 2000

    return

  if getParameterByName("method")
    document.querySelector("button#flush").click()



window.renderloopElem = document.querySelector "#renderloop"

render = ->
  window.stats.begin()

  # ---
  window.renderloopElem.textContent = window.renderloopHighest

  now = Date.now()

  delta = now - window.renderloopLast

#  window.renderloopHighest = delta unless window.renderloopHighest

  if not window.renderloopHighest or delta > window.renderloopHighest
    window.renderloopHighest = delta

  window.renderloopElem.textContent = window.renderloopHighest
  window.renderloopLast = now

  # prevents setting FPS to 0
  window.COULD_NOT_ANIMATE_EVEN_ONCE = false

  window.stats.end()

  window.requestAnimationFrame(render)

render()

window.getParameterByName = (name) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  if results
    decodeURIComponent(results[1].replace(/\+/g, " "))
  else
    null


# websocket connection
ws = new WebSocket "ws://localhost:31337/service"
ws.onopen = () ->
  console.log "websocket is open"

ws.onmessage = (messageEvent) ->
  bridgeHead(messageEvent.data)

ws.onclose = () ->
  alert "websocket is closed"

window.onhashchange = (e, b) ->
  encodedJson = location.hash.substr(18) # #%23webviewbridge:
  decodedJson = decodeURIComponent(encodedJson)
  window.bridgeHead(decodedJson)

window.bridgeHeadMessages = []
window.bridgeHead = (messageJSON) ->
  unless messageJSON[0] == "{"
    console.log "something else than json was passed to bridgehead, can't debug everything. was: #{messageJSON}"
    return

  message = JSON.parse(messageJSON)

  if message.type == "flush_end"
    showIndicator("flush completed")
    moveOnToTheNextTestIfSet(true)
    return

  if message.type == "native_end"
    showIndicator("last message received")
    moveOnToTheNextTestIfSet()
    return

  benchmarkMessage =
    native_started_at: message.native_started_at
    webview_started_at: message.webview_started_at
    webview_received_at: (new Date).toJSON()
    render_paused: window.renderloopElem.textContent
    fps: currentFps()
    method_name: message.method
    from: "native"
    mem: message.mem
    cpu: message.cpu
    payload: message.payload
    agent: navigator.userAgent + window.devicePixelRatio

  window.renderloopHighest = 0
  bridgeHeadMessages.push benchmarkMessage


document.querySelector("button#perform").onclick = ->
  direction = getParameterByName('direction') || document.querySelector("#directionElem").value

  method = getParameterByName('method') || document.querySelector("#methodElem").value
  interval = parseInt(getParameterByName('interval') || document.querySelector("#intervalLengthElem").value)
  messages = parseInt(getParameterByName('amount') || document.querySelector("#messagesElem").value)

  payloadLength = parseInt(getParameterByName('payload') || document.querySelector("#payloadLengthElem").value)

  if direction == "native"
    showIndicator("generating payload...")
    window.setTimeout =>
      payload = window.payloadGenerator(1024*payloadLength)

      window.setTimeout =>
        window.renderloopHighest = 0

        showIndicator("started #{method} (every #{interval}ms) with #{payloadLength} of payload")
        intervalSender
          method: method
          interval: interval
          messages: messages
          payload: payload
      , 5000  #eliminate pauses that might have come from payload generation
    , 500

  else
    object =
      type: "request"
      method: method
      interval: interval
      messages: messages
      payloadLength: payloadLength


    setTimeout ->
      console.log "requested payload from native"
      ws.send JSON.stringify(object)
      showIndicator "requested messages from native"
    , 5000 #eliminate pauses that might have come from payload generation

if getParameterByName("method")
  document.querySelector("button#perform").click()


nativeFlush = ->
    object =
      type: "flush"

    ws.send JSON.stringify(object)
    showIndicator "requested flush+advance from native"

document.querySelector("button#flush").onclick = ->

  if window.bridgeHeadMessages.length == 0
    nativeFlush()
    return

  popAndSend = ->
    message = window.bridgeHeadMessages.pop()

    unless message
      showIndicator "Flushing: DONE"
      nativeFlush() # to advance
      return

    showIndicator "Flushing: #{window.bridgeHeadMessages.length}"

    benchmarkMessage =
      from: "native"
      method_name: message.method_name
      native_payload_length: message.native_payload_length
      cpu: message.cpu
      mem: message.mem
      fps: message.fps
      render_paused: message.render_paused
      native_started_at: message.native_started_at
      webview_received_at: message.webview_received_at
      webview_started_at: message.webview_started_at
      agent: decodeURIComponent(generateBetterUserAgent())

    setTimeout =>
      xmlhttp = new XMLHttpRequest()
      #NOTE: when using hash, location.href is not good
      xmlhttp.open "POST", "#{window.location.origin}#{window.location.pathname}", false
      xmlhttp.setRequestHeader "Content-Type", "application/json;charset=UTF-8"
      xmlhttp.send JSON.stringify(benchmarkMessage)

      popAndSend()
    , 5

  popAndSend()
