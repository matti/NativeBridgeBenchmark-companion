# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# methods = [
#   "a.click",
#   "html.iframe",
#   "cookie",
#   "jscore.sync",
#   "xhr.async",
#   "location.href",
#   "location.hash"
# ]
#
# message_amounts = [
#   1000,
# ]
#
# intervals = [
#   1,
#   10,
#   100,
#   250,
#   500,
#   1000
# ]
#
# payloads = [
#   1,
#   32,
#   64,
#   128,
#   256,
#   512
# ]


# methods = [
#   "a.click",
#   "html.iframe",
#   "cookie",
#   "jscore.sync",
#   "xhr.async",
#   "location.href",
#   "location.hash"
# ]
#
# message_amounts = [
#   1000
# ]
#
# intervals = [
#   25
# ]
#
# payloads = [
#   1,
#   100,
#   1000
# ]

# methods = [
#   "a.click",
#   "cookie",
#   "xhr.async",
#   "location.href",
#   "location.hash",
#   "html.iframe",
#   "jscore.sync",
#   "html.script"
# ]
#
# message_amounts = [
#   100
# ]
#
# intervals = [
#   25
# ]
#
# payloads = [
#   1,
#   100,
#   1000
# ]
#
# methods.each do |method|
#   message_amounts.each do |amount|
#     intervals.each do |interval|
#       payloads.each do |payload|
#         test_name = "#{method}-#{amount}-#{interval}-#{payload}"
#         Test.create!(:name => test_name)
#         puts "#{test_name} created"
#       end
#     end
#   end
# end



# methods = [
#   "http.websockets",
#   "jscore.sync"
# ]
#
# message_amounts = [
#   10
# ]
#
# intervals = [
#   1000
# ]
#
# payloads = [
#   1000
# ]

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
#
# message_amounts = [
#   100
# ]
#
# intervals = [
#   250
# ]
#
# payloads = [
#   512
# ]

# TODO: fails here, same & replace throw error because no body is returned
# methods = [
#   "html.script",
#   "html.script.same",
#   "html.script.replace"
# ]
#
# message_amounts = [
#   100
# ]
#
# intervals = [
#   250
# ]
#
# payloads = [
#   512
# ]


# methods = [
#   "html.link",
#   "html.link.same",
#   "html.link.replace",
#   "html.object",
#   "html.object.same",
#   "html.object.replace"
# ]
#
# message_amounts = [
#   100
# ]
#
# intervals = [
#   250
# ]
#
# payloads = [
#   512
# ]


##uiwebview methods
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

# ## wkwebview methods
# methods = [
#   #"cookie", doens't fire
#   #"localStorage", doesn't work anymore in ios8
#   "http.websockets",
#   "html.iframe",
#   #"html.script", not a navigational action
#   #"html.svgImage",
#   #"html.img",
#   #"html.link",
#   "html.embed",
#   "html.object",
#   "a.click",
#   "location.hash",
#   "location.href",
#   #"xhr.async", not navigational action
#   #"xhr.sync",
#   "webkit.usercontent"
# ]

methods = [
  "jscore.sync",
  "location.href",
  "http.websockets",
  "a.click"
]


message_amounts = [
  100
]

intervals = [
  500
]

payloads = [
  1024
]

methods.each do |method|
  message_amounts.each do |amount|
    intervals.each do |interval|
      payloads.each do |payload|
        test_name = "#{method}-#{amount}-#{interval}-#{payload}"
        Test.create!(:name => test_name)
        puts "#{test_name} created"
      end
    end
  end
end
