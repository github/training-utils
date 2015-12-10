require 'octokit'
require 'date'

class TrainingClass
  attr_reader :customer, :class_name, :repo, :team
  
  def initialize(customer, class_name)
    @@token_error_message='Error: no environment variable called GITHUBTEACHER_TOKEN!'.freeze
    @@org = 'githubschool'.freeze
    @customer = customer.freeze
    @class_name = class_name.freeze
    @repo = nil
    @team = nil
    access_token = ENV['GITHUBTEACHER_TOKEN'].freeze or abort(@@token_error_message)
    @client = Octokit::Client.new :access_token => access_token
  end

  def create_repo
    repo_name = @customer + '-' + Date.today.to_s + '-' + @class_name
    @repo = @client.repository(@@org + '/' + repo_name)
    if !@repo
       @repo = @client.create_repository(repo_name,
        :organization => @@org,
        :has_issues => true,
        :has_wiki => false,
        :auto_init => true)
     end
  end

  def set_up_team
    team_name = 'team-' + @repo['name']
    @team = @client.create_team(@@org,
      :name => team_name) unless @client.org_teams(@@org).include?(team_name)
    repo_added_to_team = @client.add_team_repo(@team['id'],
      @repo['full_name'],
      :permission => 'push',
      :accept => 'application/vnd.github.ironman-preview+json')
  end

  def add_students_to_team(students)
    students << 'githubteacher'
    students.each do |student|
      @client.add_team_membership(@team['id'],
        student)
    end
  end

end
