#!/usr/bin/env ruby



export_name = ARGV[0]

raise "export_name missing" unless export_name

require "./config/environment"
require "csv"

ActiveRecord::Base.logger.level = 1


fields = ["id", "method", "fps", "mem", "cpu", "w2n", "n2w", "pause", "agent"]

known_agents = {
  #"Mozilla/5.0 (iPad; CPU OS 9_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13C752" => "ipadmini4",
  "Mozilla/5.0 (iPad; CPU OS 9_2_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13D151" => "ipadmini", #updated
  "iPhone7,12" => "iphone6plus", #updated
  "Mozilla/5.0 (iPad; CPU OS 9_2_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13D152" => "ipadair2",
  "iPod7,12" => "ipodtouch6"
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

@debuggen = false

def format(str)
  puts str if @debuggen
  "#{str}\n"
end

test_stats_output = ""
agents.each do |agent|
  test_stats_output << format("--[ #{known_agents[agent]} ]--------------")
  payloads.each do |payload|
    csv_string = CSV.generate(col_sep: ",") do |csv|
      csv << header_fields


      Test.all.each do |test|
        test_method_name, test_amount, test_interval, test_payload, others = test.name.split("-")

        next unless test_payload == payload

        test_configuration = "test-#{test_amount}-#{test_interval}-#{test_payload}"
        results_for_agent = test.results.where(agent: agent)

        pause_samples = results_for_agent.map(&:render_paused)
        pause_average = results_for_agent.average(:render_paused)
        pause_stddev = pause_samples.standard_deviation

        webview_to_native_ms_delta_samples = results_for_agent.map(&:webview_to_native_ms_delta)
        webview_to_native_ms_delta_average = webview_to_native_ms_delta_samples.mean
        webview_to_native_ms_delta_stddev = webview_to_native_ms_delta_samples.standard_deviation

        native_to_webview_ms_delta_samples = results_for_agent.map(&:native_to_webview_ms_delta)
        native_to_webview_ms_delta_average = native_to_webview_ms_delta_samples.mean
        native_to_webview_ms_delta_stddev = native_to_webview_ms_delta_samples.standard_deviation


        test_stats_output << format("#{test.name}")

        results_written = 0
        results_for_agent.each do |result|
          outlier_multiplier = 4#6
          current_pause_absolute_distance = (result.render_paused - pause_average).abs
          current_native_to_webview_ms_delta_absolute_distance = (result.native_to_webview_ms_delta - native_to_webview_ms_delta_average).abs
          current_webview_to_native_ms_delta_absolute_distance = (result.webview_to_native_ms_delta - webview_to_native_ms_delta_average).abs

          outlier_by_pause = (result.render_paused > pause_average) && current_pause_absolute_distance > outlier_multiplier*pause_stddev
          outlier_by_webview_to_native = (result.webview_to_native_ms_delta > webview_to_native_ms_delta_average) && current_webview_to_native_ms_delta_absolute_distance > outlier_multiplier*webview_to_native_ms_delta_stddev
          outlier_by_native_to_webview = (result.native_to_webview_ms_delta > native_to_webview_ms_delta_average) && current_native_to_webview_ms_delta_absolute_distance > outlier_multiplier*native_to_webview_ms_delta_stddev

          if @debuggen
            puts "#{result.render_paused} - #{result.webview_to_native_ms_delta} - #{result.native_to_webview_ms_delta}"
            puts "  pause avg: #{pause_average}, absd: #{current_pause_absolute_distance}, pstd: #{pause_stddev}, mult: #{outlier_multiplier*pause_stddev}"
            puts "  n2v avg: #{native_to_webview_ms_delta_average}, absd: #{current_native_to_webview_ms_delta_absolute_distance}, n2wd: #{native_to_webview_ms_delta_stddev}, mult: #{outlier_multiplier*native_to_webview_ms_delta_stddev}"
            puts "  w2n avg: #{webview_to_native_ms_delta_average}, absd: #{current_webview_to_native_ms_delta_absolute_distance}, n2wd: #{webview_to_native_ms_delta_stddev}, mult: #{outlier_multiplier*webview_to_native_ms_delta_stddev}"
          end

          if outlier_by_pause ||
             outlier_by_webview_to_native ||
             outlier_by_native_to_webview

            print "OUTLIER by: "
            puts "pause #{result.render_paused}" if outlier_by_pause
            puts "webview to native #{result.webview_to_native_ms_delta}" if outlier_by_webview_to_native
            puts "native to webview #{result.native_to_webview_ms_delta}" if outlier_by_native_to_webview

            next
          else
            #
          end

          result_row = []

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
                raise "unknown agent: #{result.agent}"
              end
            else
              result_row << result.send(better_field.to_sym)
            end
          end

          csv << result_row
          results_written += 1
        end
        test_stats_output << format("  total results wo/ outliers: #{results_written}")

      end #test

    end #csv
    File.write("tmp/#{known_agents[agent]}-#{export_name}-#{payload}.csv", csv_string)
    test_stats_output << format("")
  end #payloads

  File.write("tmp/#{known_agents[agent]}-#{export_name}.txt", test_stats_output)
  test_stats_output=""
end # agents
