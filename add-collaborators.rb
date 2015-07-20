# add-collaborators.rb
# add as collaborators anyone who comments on a given issue in a given repo
# assumes you created and stored the appropriate OAuth token as an ENV variable called GITHUBTEACHER_TOKEN

require 'octokit'
require 'optparse'


# Make sure arguments are specified
ARGV << '-h' if ARGV.empty?


# Create options hash
options = {}


# Parse options
OptionParser.new do |opts|
  opts.banner = "Usage: add-collaborators.rb [options]"

  opts.on("-r", "--repo REPOSITORY", "Repository Path -- ex: githubteacher/example-repo") do |r|
    options[:repo] = r
  end

  opts.on("-i", "--issue ISSUE", Numeric, "Issue Number -- ex: 4") do |i|
    options[:issue] = i
  end

  opts.on_tail("-h", "--help", "Prints this help message") do |h|
    puts opts
    exit
  end

end.parse!

puts options


# Assign variables
token = 'GITHUBTEACHER_TOKEN'
repo_name = options[:repo]
issue_num = options[:issue]


# Create a new Octokit Client
Octokit.auto_paginate = true
client = Octokit::Client.new :access_token => ENV[token]


# Get Issue Commenters and Add as Collaborators
begin
  client.issue_comments(repo_name, issue_num).each do |comment|
    username = comment[:user][:login]
    user_added = client.add_collaborator(repo_name, username)
    if !user_added
      puts "Failed to add #{username} as a collaborator"
    end
  end
rescue Octokit::NotFound
  puts "[404] - Repository not found:\nIf #{repo_name || "nil"} is correct, are you using the right Auth token?"

rescue Octokit::UnprocessableEntity
  puts "[422] - Unprocessable Entity:\nAre you trying to add collaborators to an org-level repository?"

end
