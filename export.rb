#!/usr/bin/env ruby

require "./config/environment"
require "csv"

fields = ["id", "method", "fps", "mem", "cpu", "w2n", "n2w", "pause", "agent"]

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
    agents = test.results.map(&:agent).uniq


    for agent in agents do
      results_by_agent = test.results.where("agent = ?", agent)

      offset = (results_by_agent.size / 10)
      limit = results_by_agent.size - (offset)

      puts "offset: #{offset}"
      puts "limit: #{limit}"

      export_results = results_by_agent.reorder("created_at asc").limit(limit).offset(offset)
      puts "export results: #{export_results.size}"

      export_results.each do |result|
        result_row = []

        test_method_name, test_amount, test_interval, test_payload, others = test.name.split("-")
        test_configuration = "#{test_amount}-#{test_interval}-#{test_payload}"

        result_row << test_configuration

        fields.each do |field|
          better_field = if field == "w2n"
            "webview_to_native_delta"
          elsif field == "n2w"
            "native_to_webview_delta"
          elsif field == "pause"
            "render_paused"
          elsif field == "method"
            "method_name"
          else
            field
          end

          if field == "agent"
            result_row << if result.agent == "Mozilla/5.0 (iPad; CPU OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C752"
              "iPad Mini 4"
            elsif result.agent == "Mozilla/5.0 (iPad; CPU OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C751"
              "iPad Mini"
            elsif result.agent == "Mozilla/5.0 (iPhone; CPU iPhone OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C752"
              "iPhone 5s"
            else
              "unknown"
            end
          else
            result_row << result.send(better_field.to_sym)
          end
        end

        csv << result_row
      end

    end

  end

end

File.write("tmp/all.csv", csv_string)
