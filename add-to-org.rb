#!/usr/bin/env ruby
# add USERNAME as member to ORGANIZATION and optionally to TEAM
# assumes you created and stored the appropriate OAuth token as an ENV variable called GITHUBUSER_TOKEN

require 'octokit'
require 'optparse'

# Make sure arguments are specified
ARGV << '-h' if ARGV.empty?

# Create options hash
options = {}

# Parse options
OptionParser.new do |opts|
  opts.banner = "Usage: add-to-org.rb [options]"

  opts.on("-u", "--username USERNAME", "Username for membership -- ex: githubstudent") do |u|
    options[:username] = u
  end

  opts.on("-o", "--org ORGANIZATION", "Organization name -- ex: githubschool") do |o|
    options[:org] = o
  end

  opts.on("-t", "--team TEAM_NAME", "[Optional] Team to add member to -- ex: developers") do |t|
    options[:team] = t
  end

  opts.on_tail("-h", "--help", "Prints this help message") do |h|
    puts opts
    exit
  end

end.parse!


TOKEN = ENV['GITHUBUSER_TOKEN']
abort("\nMissing GITHUBUSER_TOKEN. Please set up an OAUTH token at ") unless TOKEN

# Assign variables
#  Team is optional, so you don't need to assign it if it's nil.
username = options[:username]
org = options[:org]
team = options[:team] if !options[:team].nil?
