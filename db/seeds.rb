# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


methods = [
  "a.click",
  "html.iframe"
]

message_amounts = [
  100,
]

intervals = [
  25,
  5
]

payloads = [
  1000,
  100
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
