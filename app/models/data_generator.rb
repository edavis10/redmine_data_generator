require 'faker'
require 'random_data'

class DataGenerator
  # Generate user accounts
  def self.users(count=5)
    status = [User::STATUS_ACTIVE, User::STATUS_REGISTERED, User::STATUS_LOCKED]
    
    count.times do
      user = User.new(
                      :firstname => Faker::Name.first_name,
                      :lastname => Faker::Name.last_name,
                      :mail => Faker::Internet.free_email,
                      :status => status.rand
                      )
      # Protected from mass assignment
      user.login = Faker::Internet.user_name
      user.password = 'demo'
      user.password_confirmation = 'demo'
      user.save
    end
  end
end
