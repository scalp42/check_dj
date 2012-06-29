#!/usr/bin/env ruby

require 'optparse'

OK_STATE=0
WARNING_STATE=1
CRITICAL_STATE=2
UNKNOWN_STATE=3

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0} [OPTIONS]"

  opts.on('-w', '--warn WORKERS', 'Warn if number of workers is over WORKERS') do |val|
    options[:warn_wks] = val.to_i
  end

  opts.on('-c', '--crit WORKERS', 'Critical if number of workers is under WORKERS') do |val|
    options[:crit_wks] = val.to_i
  end

  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end
end

optparse.parse!

unless options[:crit_wks] && options[:warn_wks]
  puts optparse.help
  exit
end

current_workers =`ps -ef | grep delayed | grep -v grep`.split("\n").map { |x| x.split("\s")[10] }
#workers = `ps -ef | grep delayed | grep -v grep`.collect { |job| job =~ / -i (\d{1,2})/; $1; }

if current_workers.count > options[:warn_wks]
	puts "WARNING - There are too many workers running : #{current_workers.count}"
	exit WARNING_STATE
elsif current_workers.count < options[:crit_wks]
	puts "CRITICAL - Missing #{options[:crit_wks] - current_workers.count} workers !"
	exit CRITICAL_STATE
else
	puts "OK - #{current_workers.count} dj workers currently running."
	exit OK_STATE
end