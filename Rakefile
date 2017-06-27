require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'
require 'kitchen'
require 'versionomy'

# Style tests. Rubocop and Foodcritic
namespace :style do
  desc 'Run Ruby style checks'
  RuboCop::RakeTask.new(:ruby)

  desc 'Run Chef style checks'
  FoodCritic::Rake::LintTask.new(:chef) do |t|
    t.options = {
      fail_tags: ['any']
    }
  end
end

desc 'Run all style checks'
task style: ['style:ruby', 'style:chef']

desc 'Run Test Kitchen - all combinations'
task :integration do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each do |instance|
    instance.test(:always)
  end
end

desc 'Run Test Kitchen - Converge'
task :converge do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each(&:converge)
end

desc 'Run Test Kitchen - Verify'
task :verify do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each(&:verify)
end

desc 'Bump version number'
task :bump, :type do |_t, args|
  args.with_defaults(type: tiny)
  content = File.read('metadata.rb')
  version_pattern = /(version.*?')(.*?)(')/
  current_version = content.match(version_pattern)[2]
  next_version    = Versionomy.parse(Regexp.last_match[2]).bump(args.type).to_s
  File.write('metadata.rb', content.gsub(version_pattern, "\\1#{next_version}\\3"))
  puts "Successfully bumped from #{current_version} to #{next_version}!"
end

desc 'Run Test Kitchen - Test'
task :integration_latest do
  Kitchen.logger = Kitchen.default_file_logger
  Kitchen::Config.new.instances.each(&:test)
end

# Default
task default: %w[style]
task test: %w[style converge verify]
task full: %w[style integration_latest]
