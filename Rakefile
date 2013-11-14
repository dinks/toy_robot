require "bundler/gem_tasks"

require 'flog'
require 'flay'
require 'roodi'
require 'roodi_task'
require 'metric_fu'

# Code Complexity
desc "Analyze Code Complexity"
task :flog do
  flog = Flog.new
  flog.flog_files ['lib']
  threshold = 50

  bad_methods = flog.totals.select do |name, score|
    score > threshold
  end
  bad_methods.sort { |a,b| a[1] <=> b[1] }.each do |name, score|
    puts "%8.1f: %s" % [score, name]
  end

  raise "#{bad_methods.size} methods have a flog complexity > #{threshold}" unless bad_methods.empty?
end

# Code Dupilcation
desc "Analyze for code duplication"
task :flay do
  threshold = 25
  flay = Flay.new({:fuzzy => false, :verbose => false, :mass => threshold})
  flay.process(*Flay.expand_dirs_to_files(['lib']))

  flay.report

  raise "#{flay.masses.size} chunks of code have a duplicate mass > #{threshold}" unless flay.masses.empty?
end

# Code Quality
RoodiTask.new 'roodi', ['lib/**/*.rb'], 'roodi.yml'

task :quality => [:flog, :flay, :roodi, 'metrics:all']

