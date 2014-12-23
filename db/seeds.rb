
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
raise "Unknown direction: #{direction}" unless ["native", "webview"].include? direction

if direction == "native"
  if webview == "uiwebview"
    #uiwebview methods
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
      "location.href"
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
      "location.hash",
      "location.href",
      #"xhr.async", not navigational action
      #"xhr.sync"
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
    # TODO: wat?
    methods = [
      "http.websockets"
    ]
  end
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
