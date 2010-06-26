require 'rubygems'
require 'rake'

begin
  require 'spec/rake/spectask'

  Spec::Rake::SpecTask.new do |t|
    t.spec_opts = ["--format progress", "--color"]
  end
rescue LoadError
  puts "Please install RSpec"
end

begin
  require 'cucumber'
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:cucumber) do |t|
    t.cucumber_opts = "--format pretty"
  end
rescue LoadError
  desc 'Cucumber rake task not available'
  task :cucumber do
    abort 'Install cucumber as a gem to run tests.'
  end
end

task :default => [:spec, :cucumber]
