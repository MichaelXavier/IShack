Given /^I have an image "(.*)"$/ do |filename|
  # Created with FakeFS
  File.open(filename, "w") {|f| f.write("junk")}
end

Given %(I have configured my API key) do
  ENV['ISHACK_KEY'] ||= "test"
end

When %(I run ishack with options:) do |table|
  opts = table.hashes.first.inject({}) {|h,(k,v)| h.merge(k.to_sym => v)}
  opts[:items] = opts[:items].split(' ') if opts[:items]
  opts[:key] = ENV['ISHACK_KEY']
  opts[:transload] = opts[:transload] == 'true'
  @output_monitor = StringIO.new
  uploader = IShack::Uploader.new(opts)
  uploader.output = @output_monitor
  uploader.run
end

Then /^I should see (\d+) URLs?$/ do |n|
  pat = /(http|https):\/\/[\w]+([\-\.]{1}[\w]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?/ix
  @output_monitor.rewind
  @output_monitor.read.scan(pat).length.should == n.to_i
  @output_monitor.rewind
end
