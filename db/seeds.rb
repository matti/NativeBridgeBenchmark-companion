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



methods = [
  "http.websockets",
  "jscore.sync"
]

message_amounts = [
  10
]

intervals = [
  1000
]

payloads = [
  1000
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
