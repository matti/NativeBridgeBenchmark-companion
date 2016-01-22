#!/usr/bin/env ruby

require "./config/environment"
require "csv"

fields = ["id", "method", "fps", "mem", "cpu", "w2n", "n2w", "pause", "agent"]

known_agents = {
  "Mozilla/5.0 (iPad; CPU OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C752" => "ipad_mini_4",
  "Mozilla/5.0 (iPad; CPU OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C751" => "ipad_mini",
  "Mozilla/5.0 (iPhone; CPU iPhone OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C752" => "iphone_5s"
}


# test = Test.first
#
# test_name, others = test.name.split("-")
# header_fields = fields.map { |f| "#{test_name} #{f}" }

header_fields = ["configuration"] + (fields)

agents = Result.all.map(&:agent).uniq

puts agents.inspect

agents.each do |agent|
  csv_string = CSV.generate(col_sep: ",") do |csv|
    csv << header_fields

    Test.all.each do |test|

      puts "test: #{test.name}"
      puts "results: #{test.results.size}"

      test.results.each do |result|
        result_row = []

        test_method_name, test_amount, test_interval, test_payload, others = test.name.split("-")
        test_configuration = "test-#{test_amount}-#{test_interval}-#{test_payload}"

        result_row << test_configuration

        fields.each do |field|
          better_field = if field == "w2n"
            "webview_to_native_ms_delta"
          elsif field == "n2w"
            "native_to_webview_ms_delta"
          elsif field == "pause"
            "render_paused"
          elsif field == "method"
            "method_name"
          else
            field
          end

          if field == "agent"
            result_row << if known_agents[result.agent]
              known_agents[result.agent]
            else
              "unknown"
            end
          else
            result_row << result.send(better_field.to_sym)
          end
        end

        csv << result_row if agent == result.agent

      end

    end
  end

  File.write("export/#{known_agents[agent]}.csv", csv_string)
end
