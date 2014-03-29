require "bundler/setup"
require "bundler/gem_tasks"
require "bump/tasks"

task :default do
  Dir["spec/fixtures/*"].each { |dir| Bundler.with_clean_env { `cd #{dir} && bundle --check || bundle --quiet` } }
  sh "rspec spec/"
end
