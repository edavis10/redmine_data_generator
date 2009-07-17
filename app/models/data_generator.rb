require 'faker'
require 'random_data'

class DataGenerator
  UserStatuses = [User::STATUS_ACTIVE, User::STATUS_REGISTERED, User::STATUS_LOCKED]

  # Generate issues
  def self.issues(count=100)
    projects = Project.all
    status = IssueStatus.all
    priorities = IssuePriority.all
    users = User.all

    ActiveRecord::Base.observers = []
    count.times do |i|
      issue = Issue.new(
                        :tracker => Tracker.find(:first),
                        :project => projects.rand, # from faker gem
                        :subject => Faker::Company.catch_phrase,
                        :description => Random.paragraphs(3),
                        :status => status.rand,
                        :priority => priorities.rand,
                        :author => users.rand,
                        :assigned_to => users.rand
                        )
      unless issue.save
        Rails.logger.error issue.errors.full_messages
      end
    end

  end
  
  # Generate projects and members
  def self.projects(count=5)
    count.times do |n|
      project = Project.create(
                               :name => Faker::Company.catch_phrase[0..29],
                               :description => Faker::Company.bs,
                               :homepage => Faker::Internet.domain_name,
                               :identifier => Faker::Internet.domain_word[0..16] + n.to_s
                               )
      project.trackers = Tracker.find(:all)
      if project.save
        # Roles
        roles =  Role.find(:all).reject {|role|
          role.builtin == Role::BUILTIN_NON_MEMBER || role.builtin == Role::BUILTIN_ANONYMOUS
        }

        User.all(:conditions => ['status IN (?)', UserStatuses ]).each do |user|
          Member.create({:user => user, :project => project, :roles => [roles.rand]})
        end
      else
        Rails.logger.error project.errors.full_messages
      end
    end
  end

  # Generate user accounts
  def self.users(count=5)
    count.times do
      user = User.new(
                      :firstname => Faker::Name.first_name,
                      :lastname => Faker::Name.last_name,
                      :mail => Faker::Internet.free_email,
                      :status => User::STATUS_ACTIVE
                      )
      # Protected from mass assignment
      user.login = Faker::Internet.user_name
      user.password = 'demo'
      user.password_confirmation = 'demo'
      user.save
    end
  end
end
