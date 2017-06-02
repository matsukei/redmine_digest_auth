require 'pathname'

module RedmineDigestAuth
  def self.root
    @root ||= Pathname.new File.expand_path('..', File.dirname(__FILE__))
  end
end

# Load patches for Redmine
Rails.configuration.to_prepare do
  Dir[RedmineDigestAuth.root.join('app/patches/**/*_patch.rb')].each { |f| require_dependency f }
end
