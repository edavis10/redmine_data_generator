require 'redmine'

Redmine::Plugin.register :redmine_data_generator do
  name 'Data Generator'
  author 'Eric Davis'
  url 'https://projects.littlestreamsoftware.com/projects/redmine-misc'
  author_url 'http://www.littlestreamsoftware.com'
  description 'The Redmine Data Generator plugin is used to quickly generate a bunch of data for Redmine.'
  version '0.1.0'

  requires_redmine :version_or_higher => '0.8.0'
end
