require "./config/environment"

csvs = Dir.glob("/Users/mpa/Dropbox/Public/gradu/*.csv")

for csv in csvs do

    contents = File.read(csv)
    rows = contents.split("\n")

    header = rows.shift

    puts File.basename(csv)

    by_method = {}
    rows.each do |row|
#      test-100-1000-256,19105,xhrpost.sync,59,20848.6,13.6,21.9998359680176,-1000.0,28,ipodtouch6
      lol1,lol2,method = row.split(",")
      by_method[method] ||= []
      by_method[method] << row
    end

    new_contents = "#{header}\n"

    for key in by_method.keys
      results = by_method[key].size
      offset = results/10

      middle_part = by_method[key][offset,results-(2*offset)]
      new_contents << middle_part.join("\n")
      new_contents << "\n"
    end

    File.write("trimmed/#{File.basename(csv)}", new_contents)
end
