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
    count.to_i.times do |i|
      project = projects.rand
      parent_id = if [true, false].rand && project.issues.count > 0
                    project.issues.first(:offset => (1..project.issues.count).to_a.rand).try(:id)
                  end
      
      issue = Issue.new(
                        :tracker => Tracker.find(:first),
                        :project => project,
                        :subject => Faker::Company.catch_phrase,
                        :description => Random.paragraphs(3),
                        :status => status.rand,
                        :priority => priorities.rand,
                        :author => users.rand,
                        :assigned_to => users.rand,
                        :start_date => (1..120).to_a.rand.days.ago.to_date.to_s,
                        :due_date => (1..120).to_a.rand.days.from_now.to_date.to_s,
                        :parent_issue_id => parent_id
                        )
      unless issue.save
        Rails.logger.error issue.errors.full_messages
      end
    end

  end
  
  # Generate projects and members
  def self.projects(count=5)
    count.to_i.times do |n|
      parent = if [true, false].rand && Project.count > 0
                 Project.first(:offset => (1..Project.count).to_a.rand)
               end
                 
      project = Project.create(
                               :name => Faker::Company.catch_phrase[0..29],
                               :description => Faker::Company.bs,
                               :homepage => Faker::Internet.domain_name,
                               :identifier => Faker::Internet.domain_word[0..16] + n.to_s
                               )
      project.set_parent!(parent) if parent
      
      project.trackers = Tracker.find(:all)
      if project.save
        # Roles
        roles =  Role.find(:all).reject {|role|
          role.builtin == Role::BUILTIN_NON_MEMBER || role.builtin == Role::BUILTIN_ANONYMOUS
        }

        User.all(:conditions => ['status IN (?)', UserStatuses ]).each do |user|
          Member.create({:user => user, :project => project, :roles => [roles.rand]})
        end

        Redmine::AccessControl.available_project_modules.each do |module_name|
          EnabledModule.create(:name => module_name.to_s, :project => project)
        end
      else
        Rails.logger.error project.errors.full_messages
      end
    end
  end

  # Generate time entries
  def self.time_entries(count=100)
    users = User.all
    issues = Issue.all
    activities = TimeEntryActivity.all
      
    count.to_i.times do
      issue = issues.rand
      te = TimeEntry.new(
                       :project => issue.project,
                       :user => users.rand,
                       :issue => issue,
                       :hours => (1..20).to_a.rand,
                       :comments => Faker::Company.bs,
                       :activity => activities.rand,
                       :spent_on => Random.date
                         )
      unless te.save
        Rails.logger.error te.errors.full_messages
      end
    end
 
  end
  
  # Generate user accounts
  def self.users(count=5)
    count.to_i.times do
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
