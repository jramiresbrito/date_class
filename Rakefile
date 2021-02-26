require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "--require ./bonus_formatter.rb --format BonusFormatter"
end

desc "Look for style guide offenses in your code"
task :rubocop do
  sh "rubocop --format simple || true"
end

desc "Launch tests for the date namespace only"
task :date do
  sh "rspec -t date"
end

task default: %i[rubocop spec date]
