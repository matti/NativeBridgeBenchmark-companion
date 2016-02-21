#!/usr/bin/env ruby

export_name = ARGV[0]

raise "export_name missing" unless export_name

require "./config/environment"
require "csv"

fields = ["id", "method", "fps", "mem", "cpu", "w2n", "n2w", "pause", "agent"]

known_agents = {
  "Mozilla/5.0 (iPad; CPU OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C752" => "ipadmini4",
  "Mozilla/5.0 (iPad; CPU OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C751" => "ipadmini",
  "Mozilla/5.0 (iPhone; CPU iPhone OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C752" => "iphone5s"
}


# test = Test.first
#
# test_name, others = test.name.split("-")
# header_fields = fields.map { |f| "#{test_name} #{f}" }

header_fields = ["configuration"] + (fields)

agents = Result.all.map(&:agent).uniq
test_names = Test.all.map(&:name).uniq

payloads = []
test_names.each do |test_name|
  test_method_name, test_amount, test_interval, test_payload, others = test_name.split("-")
  payloads << test_payload
end
payloads.uniq!


module Enumerable

    def sum
      self.inject(0){|accum, i| accum + i }
    end

    def mean
      self.sum/self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.inject(0){|accum, i| accum +(i-m)**2 }
      sum/(self.length - 1).to_f
    end

    def standard_deviation
      return Math.sqrt(self.sample_variance)
    end

end

agents.each do |agent|
  payloads.each do |payload|
    csv_string = CSV.generate(col_sep: ",") do |csv|
      csv << header_fields

      Test.all.each do |test|

        puts "test: #{test.name}"
        puts "results: #{test.results.size}"

        pause_samples = test.results.map(&:render_paused)
        pause_average = test.results.average(:render_paused)
        pause_stddev = pause_samples.standard_deviation

        puts "pause_average: #{pause_average}"
        puts "pause std dev: #{pause_stddev}"


        test.results.each do |result|
          current_pause_absolute_distance = (result.render_paused - pause_average).abs
          if current_pause_absolute_distance > 2*pause_stddev
            puts "OUTLIER: #{current_pause_absolute_distance} vs #{2*pause_stddev}"
            next
          else
            puts "not outleir"
          end

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

          csv << result_row if agent == result.agent && payload == test_payload

        end

      end
    end

    File.write("tmp/#{known_agents[agent]}-#{export_name}-#{payload}.csv", csv_string)
  end
end
