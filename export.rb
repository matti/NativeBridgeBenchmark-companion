
require "./config/environment"
require "csv"

Test.all.each do |test|

  fields = ["id", "method_name", "fps", "mem", "cpu", "webview_to_native_delta"]

  test_name, others = test.name.split("-")
  header_fields = fields.map { |f| "#{test_name} #{f}" }


  csv_string = CSV.generate(col_sep: ",") do |csv|

    csv << header_fields

    puts "test: #{test}"
    puts "results: #{test.results.size}"

    test.results.each do |result|
      result_row = []
      fields.each do |field|
        result_row << result.send(field.to_sym)
      end

      csv << result_row
    end
  end

  File.write("export/#{test.name}.csv", csv_string)
end
