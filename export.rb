#!/usr/bin/env ruby

require "./config/environment"
require "csv"

fields = ["id", "method_name", "fps", "mem", "cpu", "webview_to_native_delta", "render_paused"]

# test = Test.first
#
# test_name, others = test.name.split("-")
# header_fields = fields.map { |f| "#{test_name} #{f}" }

header_fields = ["configuration"] + (fields)

csv_string = CSV.generate(col_sep: ",") do |csv|
  csv << header_fields


  Test.all.each do |test|

    puts "test: #{test}"
    puts "results: #{test.results.size}"

    offset = (test.results.size / 10)
    limit = test.results.size - (2*offset)

    puts "offset: #{offset}"
    puts "limit: #{limit}"

    export_results = test.results.reorder("created_at asc").limit(limit).offset(offset)
    puts "export results: #{export_results.size}"

    export_results.each do |result|
      result_row = []

      test_method_name, test_amount, test_interval, test_payload, others = test.name.split("-")
      test_configuration = "#{test_amount}-#{test_interval}-#{test_payload}"

      result_row << test_configuration

      fields.each do |field|
        result_row << result.send(field.to_sym)
      end


      csv << result_row
    end

  end

end

File.write("export/all.csv", csv_string)
