require File.dirname(__FILE__) + '/../test_helper'

class DataGeneratorTest < Test::Unit::TestCase
  context "#all" do
    should "run users"
    should "run projects"
    should "run issues"
    should "run journals"
    should "run time_entries"
  end

  context "#users" do
    should "generate 5 random users by default" do
      assert_difference("User.count",5) do
        DataGenerator.users
      end
    end

    should "generate x random users with a parameter" do
      assert_difference("User.count", 50) do
        DataGenerator.users 50
      end
    end
  end

  context "#projects" do
    should "generate 5 random projects by default"
    should "generate x random projects with a parameter"
    should "assign all users to the project"
  end

  context "#issues" do
    should "generate 100 random issues by default"
    should "generate x random issues with a parameter"
  end

  context "#journals" do
    should "generate 100 random journal entries by default"
    should "generate x random journal entries with a parameter"
  end

  context "#time_entries" do
    should "generate 100 random time entries by default"
    should "generate x random time entries with a parameter"
  end
end
