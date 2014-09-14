
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
  requestURL = "nativebridge://ping?webview_started_at=#{now.toJSON()}&payload=#{opts.payload}&method_name=#{opts.method}&fps=#{opts.currentFps}&render_paused=#{opts.currentRenderLoopPause}"

  return requestURL;

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

window.sendWithWebSockets = (opts={}) ->
  window.WebSocketTest2(generateRequestURL(opts))

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
  svgElem = document.createElementNS 'http://www.w3.org/2000/svg', 'svg'
  svgElem.width = "100px"
  svgElem.height = "100px"
  svgElem.xmlns = "http://www.w3.org/2000/svg"

  svgImageElem = document.createElementNS 'http://www.w3.org/2000/svg', 'image'
  svgImageElem.setAttributeNS 'http://www.w3.org/1999/xlink','href', "http://#{generateRequestURL(opts)}"

  svgElem.appendChild(svgImageElem)

  document.body.appendChild(svgElem)

window.sendWithHtmlSvgImageSame = (opts={}) ->
  svgImageElem = document.querySelector("svg image.nativebridge")
  svgImageElem.setAttributeNS 'http://www.w3.org/1999/xlink','href', "http://#{generateRequestURL(opts)}"

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

window.intervalSender = (opts={}) ->

  messagesLeft = opts.messagesLeft || opts.messages
  messagesLeft = messagesLeft - 1

  # TODO: check that works also:

  currentFps = parseInt(stats.domElement.firstChild.textContent)

  if window.COULD_NOT_ANIMATE_EVEN_ONCE
    currentFps = 0
  else
    window.COULD_NOT_ANIMATE_EVEN_ONCE = true

  nativeOptions =
    payload: opts.payload
    method: opts.method
    currentFps: currentFps
    currentRenderLoopPause: window.renderloopElem.textContent

  setTimeout =>
    currentMessageIndex = opts.messages - messagesLeft
    window.showIndicator "Sending message #{currentMessageIndex}/#{opts.messages}"

    if opts.method == "location.href"
      sendWithLocationHref nativeOptions
    else if opts.method == "location.hash"
      sendWithLocationHash nativeOptions
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

    window.renderloopHighest = 0

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


window.renderLoopInterval = 10
window.renderloopElem = document.querySelector("#renderloop");

window.setInterval ->
  now = Date.now()

  delta = now - window.renderloopLast - window.renderLoopInterval

  window.renderloopHighest = delta unless window.renderloopHighest

  if delta > window.renderloopHighest
    window.renderloopHighest = delta

  #window.renderloopElem.textContent = delta + " " + window.renderloopHighest
  window.renderloopElem.textContent = window.renderloopHighest

  window.renderloopLast = now
, window.renderLoopInterval

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
      window.renderloopHighest = 0

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
