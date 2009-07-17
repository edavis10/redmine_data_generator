namespace :data_generator do
  desc "Generates random data for all supported datatypes"
  task :all => [:environment, :users, :projects, :issues, :time_entries]
  
  desc "Generate random issues.  Default: 100, override with COUNT=x"
  task :issues => :environment do
    DataGenerator.issues ENV['COUNT'] || 100
  end

  desc "Generate random projects.  Default: 5, override with COUNT=x"
  task :projects => :environment do
    DataGenerator.projects ENV['COUNT'] || 5
  end

  desc "Generate random time entries.  Default: 100, override with COUNT=x"
  task :time_entries => :environment do
    DataGenerator.time_entries ENV['COUNT'] || 100
  end

  desc "Generate random users.  Default: 5, override with COUNT=x"
  task :users => :environment do
    DataGenerator.users ENV['COUNT'] || 5
  end
end
