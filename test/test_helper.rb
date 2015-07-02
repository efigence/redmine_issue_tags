# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

# Set fixtures root
ActiveSupport::TestCase.fixture_path=(File.expand_path("../fixtures",  __FILE__))
ActiveSupport::TestCase.fixtures :all

Tag = ActsAsTaggableOn::Tag
Tagging = ActsAsTaggableOn::Tagging
