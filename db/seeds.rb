
# methods = [
#   "html.iframe",
#   "html.iframe.same",
#   "html.iframe.replace",
#   "html.embed",
#   "html.embed.same",
#   "html.embed.replace",
#   "html.script",
#   "html.script.same",
#   "html.script.replace",
#   "html.svgImage",
#   "html.svgImage.same",
#   "html.svgImage.replace",
#   "html.img",
#   "html.img.same",
#   "html.img.replace",
#   "html.link",
#   "html.link.same",
#   "html.link.replace",
#   "html.object",
#   "html.object.same",
#   "html.object.replace"
# ]

# TODO: fails here, same & replace throw error because no body is returned
# methods = [
#   "html.script",
#   "html.script.same",
#   "html.script.replace"
# ]


webview = ARGV[1]
direction = ARGV[2]

raise "Unknown webview: #{webview}" unless ["uiwebview", "wkwebview"].include? webview
raise "Unknown direction: #{direction}" unless ["native", "webview", "nativesync"].include? direction

if direction == "native"
  if webview == "uiwebview"
    methods = [
      #"cookie", doesn't work anymore mihail agrees.
      #"localStorage", doesn't work anymore in ios8
      "http.websockets",
      "jscore.sync",
      "html.iframe",
      "html.script",
      "html.svgImage",
      "html.img",
      "html.link",
      "html.embed",
      "html.object",
      "xhr.async",
      "xhr.sync",
      "a.click",
      "location.hash",
      "location.replaceHash",
      "location.replace",
      "location.href",
      "prompt",
      "alert",
      "confirm"
    ]
  elsif webview == "wkwebview"
    methods = [
      "webkit.usercontent",
      #"cookie", doens't fire
      #"localStorage", doesn't work anymore in ios8
      "http.websockets",
      "html.iframe",
      #"html.script", not a navigational action
      #"html.svgImage",
      #"html.img",
      #"html.link",
      "html.embed",
      "html.object",
      "a.click",
      "location.replaceHash",
      "location.replace",
      "location.hash",
      "location.href",
      #"xhr.async", not navigational action
      #"xhr.sync"
      "webkit.alert",
      "webkit.prompt",
      "webkit.confirm",
      "webkit.title",
    ]
  end
elsif direction == "webview"
  if webview == "uiwebview"
    methods = [
      "location.hash",
      "webview.eval",
      "jscore.sync",
      "http.websockets"
    ]
  elsif webview == "wkwebview"
    #TODO: surely more?
    methods = [
      "http.websockets",
      "webview.eval",
      "location.hash"
    ]
  end

elsif direction == "nativesync"
  if webview == "uiwebview"
    methods = [
      "jscore.pongweb",
      "xhr.sync",
      "prompt.pongweb"
    ]
  elsif webview == "wkwebview"
    methods = [
      #"webkit.usercontent", no return value jscore is acually better
      "prompt.pongweb"
    ]
  end
# TODO: this is hard to do with this architecture + not very interesting
# elsif direction == "webviewsync"
#   if webview == "uiwebview"
#     methods = [
#       #"jscore.sync", #TODO
#       "webview.evalpong" #TODO
#     ]
#   elsif webview == "wkwebview"
#     methods = [
#       "webview.eval" #TODO
#     ]
#   end

end


message_amounts = [
  5
]

intervals = [
  1000
]

payloads = [
  1000
]

#TODO: webview.eval

methods.each do |method|
  message_amounts.each do |amount|
    intervals.each do |interval|
      payloads.each do |payload|
        test_name = "#{method}-#{amount}-#{interval}-#{payload}-#{direction}"
        Test.create! name: test_name
        puts "#{test_name} created"
      end
    end
  end
end

exit 0
