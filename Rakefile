require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

desc 'Fail on known vulnerabilities in the bundle'
task :audit do
  sh 'bundle exec bundle-audit check --update'
end

desc 'Fail on duplicated code (flay exits 0 even when it finds some)'
task :flay do
  report = `bundle exec flay lib spec`
  puts report
  abort 'Duplicated code found' if report.match?(/(Similar|IDENTICAL) code found/)
end

desc 'The whole pre-push gate: lint, audit, duplication, specs with 100% coverage'
task ci: %i[rubocop audit flay spec]

task default: :ci
