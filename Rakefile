# -*- ruby -*-
$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'rubygems'
require 'config/vendorized_gems'
require 'taza'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'rake/clean'

ARTIFACTS_DIR = 'artifacts'

RCOV_THRESHOLD = 100.0
RCOV_DIR = File.join(ARTIFACTS_DIR,"rcov")

FLOG_THRESHOLD = 40.0
FLOG_REPORT = File.join(ARTIFACTS_DIR,"flog_report.txt")
FLOG_LINE = /^(.*): \((\d+\.\d+)\)/

files_in_gem = FileList["[A-Z]*.*", "{bin,lib,spec,app_generators,watircraft_generators}/**/*"]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = 'watircraft'
    s.rubyforge_project = 'watir' 
    s.email = "bret@pettichord.com"
    s.homepage = "http://wiki.github.com/bret/watircraft"
    s.summary = "WatirCraft is a framework for testing web apps."
    s.description = s.summary
    s.authors = ["Bret Pettichord", "Jim Matthews", "Charley Baker", "Adam Anderson"]

    s.executables = ["watircraft"] 
    s.files = files_in_gem

    s.add_dependency(%q<taglob>, [">= 1.1.1"])
    s.add_dependency(%q<rake>, [">= 0.8.3"])
    s.add_dependency(%q<mocha>, [">= 0.9.3"])
    s.add_dependency(%q<rubigen>, [">= 1.4.0"])
    s.add_dependency(%q<rspec>, [">= 1.1.12"])
    s.add_dependency(%q<cucumber>, [">= 0.1.16"])

    s.requirements << 'watir(ie) and/or firewatir 1.6.2 or newer'

    s.extra_rdoc_files = ["History.txt", "README.rdoc"]
    s.has_rdoc = true
    s.rdoc_options = ["--main", "README.rdoc"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end  

desc "Build RDoc"
task :rdoc do
  system "ruby ./vendor/gems/gems/allison-2.0.3/bin/allison --line-numbers --inline-source --main README --title 'Taza RDoc' README History.txt lib "
end

Spec::Rake::SpecTask.new do |t|
  t.libs << File.join(File.dirname(__FILE__), 'lib')
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Run all examples with RCov"
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.libs << File.join(File.dirname(__FILE__), 'lib')
  t.rcov = true
  t.rcov_dir = RCOV_DIR
  t.rcov_opts << '--text-report'
  t.rcov_opts << '--exclude spec'
end

desc "Verify Code Coverage"
RCov::VerifyTask.new(:verify_rcov => :rcov) do |t|
  t.threshold = RCOV_THRESHOLD
  t.index_html = File.join(RCOV_DIR,"index.html")
end

desc "Run flog against all the files in the lib"
task :flog do
  require "flog"
  flogger = Flog.new
  flogger.flog_files Dir["lib/**/*.rb"]
  FileUtils.mkdir_p(ARTIFACTS_DIR)
  File.open(FLOG_REPORT,"w") {|file| flogger.report file }
  puts File.readlines(FLOG_REPORT).select {|line| line =~ FLOG_LINE || line =~ /Total Flog/}
end
 
desc "Verify Flog Score is under threshold"
task :verify_flog => :flog do |t|
  # I hate how ridiclous this is (Adam)
  messages = File.readlines(FLOG_REPORT).inject([]) do |messages,line|
    line =~ FLOG_LINE && $2.to_f > FLOG_THRESHOLD ?
      messages << "#{$1}(#{$2})" : messages
  end
  #lol flog log
  flog_log = "\nFLOG THRESHOLD(#{FLOG_THRESHOLD}) EXCEEDED\n #{messages.join("\n ")}\n\n"
  raise flog_log unless messages.empty?
end

desc "Run saikuro cyclo complexity against the lib"
task :saikuro do
  #we can specify options like ignore filters and set warning or error thresholds
  system "ruby vendor/gems/gems/Saikuro-1.1.0/bin/saikuro -c -t -i lib -y 0 -o #{ARTIFACTS_DIR}/saikuro"
end

desc "Should you check-in?"
task :quick_build => [:verify_rcov, :verify_flog]

file "lib/watircraft/version.rb" => 'VERSION.yml' do 
  require 'jeweler'
  version = Jeweler::Version.new('.')
  File.open("lib/watircraft/version.rb", "w") do |file|
    file.puts "# This file is autogenerated. Do not edit." 
    file.puts "# Use 'rake version.rb' to update."
    file.puts "module WatirCraft; VERSION = '#{version}'; end"
  end
end

task :gemspec => ["lib/watircraft/version.rb", 'Manifest.txt']

CLEAN << 'pkg' << FileList['*.gem'] << 'Manifest.txt'

namespace :gem do
  desc "Uninstall all watircraft gems"
  task :uninstall do
    system("call gem uninstall watircraft --all --executables")
  end
  desc "Install the current watircraft gem (because other install task is broken on windows)"
  task :install_win do
    require 'jeweler'
    version = Jeweler::Version.new('.')
    system("call gem install ./pkg/watircraft-#{version}.gem")
  end
end

desc "Install new gem after uninstalling previous"
task :install => ['gem:uninstall', 'gem:install_win']

file 'Manifest.txt' => :clean do
  File.open('Manifest.txt', 'w') do |f|
    f.puts files_in_gem
  end
end

desc "Build and install a gem from scratch"
task "build" => ['gemspec', 'gem', 'install'] 

# vim: syntax=ruby
