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
team_name = options[:team] if !options[:team].nil?


# Create a new Octokit Client
Octokit.auto_paginate = true
@client = Octokit::Client.new :access_token => TOKEN

# If the team doesn't exist yet, create it
#  otherwise, get the team_id from the list
# Once we have the team_id we can add people to it
#  regardless of them being a member of the organization yet
def add_to_team_and_org(team_name, username, org)

  team_id = nil
  team_list = @client.org_teams(org)

  team_list.each do |team|
    if team.name == team_name
      team_id = team.id
    end
  end

  if team_id.nil?
    # TODO: what ways can this fail that we need to rescue for?
    response = @client.create_team(org, {:name => team_name})
    team_id = response.id
    puts "Team '#{team_name}' created at https://github.com/orgs/#{org}/teams" unless team_id.nil?
  end

  # Add username to team_id
    @client.add_team_membership(team_id, username)
    puts "#{username} added to #{team_name}."
end

if !team_name.nil?
  add_to_team_and_org(team_name, username, org)
else
  #add_to_org(username, org)
end
