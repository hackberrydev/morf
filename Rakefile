require "rake/testtask"
require "standard/rake_task"

Standard::RakeTask.new

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

task default: %i[standard test]
