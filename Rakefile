require 'rake'

begin
  require 'spec/rake/spectask'

  Spec::Rake::SpecTask.new do |t|
    t.spec_opts = ["--format progress", "--color"]
  end
rescue LoadError
  puts "Please install RSpec"
end
