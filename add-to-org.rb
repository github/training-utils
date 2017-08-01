#!/usr/bin/env ruby
# add USERNAME as member to ORGANIZATION and optionally to TEAM
# assumes you created and stored the appropriate OAuth token as an ENV variable called GITHUBTEACHER_TOKEN

require 'octokit'
require 'optparse'

# Make sure arguments are specified
ARGV << '-h' if ARGV.empty?

# Create options hash
options = {}

# Parse options
OptionParser.new do |opts|
  opts.banner = "Usage: add-to-org.rb [options]
       NOTICE: This also assumes you have set up the variable GITHUBTEACHER_TOKEN with administrative privilages.\n\n"

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


TOKEN = ENV['GITHUBTEACHER_TOKEN']
abort("Missing GITHUBTEACHER_TOKEN. Please set up an OAUTH token and set it in the environment by typing\n
export GITHUBTEACHER_TOKEN=XXXXXXXXXXXXXXXXXXXXXXX\n
and replace the Xs with your actual token. Reminder: This token needs admin privilages onto your organization in order to be inviting people.") unless TOKEN

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

  team_id = get_team_id(team_name, org)
  create_team(org, team_name, org) unless !team_id.nil?

  # Add username to team_id
  # Slightly different than adding them as a member.
  # If the username includes ","s, split it because it's a full list!
  # TODO: break this out into it's own method detected early on?
  begin
    if username.include?(",")
      username.split(",").each do |name|
        @client.add_team_membership(team_id, name)
        puts "#{name} added to #{team_name}."
      end
    else
      @client.add_team_membership(team_id, username)
      puts "#{username} added to #{team_name}."
    end
  rescue Octokit::Forbidden
    abort "[403] - Unable to add member to organization. Check that the GITHUBTEACHER_TOKEN was created with administrative privilages so that you can add members to the organization"
  end

end

# Returns team_id
def create_team(team_id, team_name, org)
  begin
    response = @client.create_team(org, {:name => team_name})
  rescue Octokit::Forbidden
    abort "[403] - Unable to add member to organization. Check that the GITHUBTEACHER_TOKEN was created with administrative privilages so that you can add members to the organization"
  end
  team_id = response.id
  puts "Team '#{team_name}' created at https://github.com/orgs/#{org}/teams" unless team_id.nil?

  team_id
end

def get_team_id(team_name, org)
  team_id = nil
  team_list = @client.org_teams(org)

  team_list.each do |team|
    if team.name == team_name
      team_id = team.id
    end
  end
  team_id

end

# If they just want to add users as members, skip the team
def add_to_org(org, username)
  begin
    @client.update_organization_membership(org, {:user => username})
  rescue Octokit::Forbidden
    abort "[403] - Unable to add member to organization. Check that the GITHUBTEACHER_TOKEN was created with administrative privilages so that you can add members to the organization"
  end
end

if !team_name.nil?
  add_to_team_and_org(team_name, username, org)
else
  add_to_org(org, username)
end
