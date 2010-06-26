require 'spec'
require 'lib/ishack'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Spec::Runner.configure do |config|
  config.mock_with :rr

  config.before(:all) do
    FakeWeb.clean_registry
    FakeWeb.register_uri(:post, 
                        IShack::Uploader.api_uri, 
                        :body   => "<image_link>http://imageshack.us/link/to/image.jpg</image_link>",
                        :status => ["200"])
    FakeFS.activate!
    FakeWeb.allow_net_connect = false
  end

  config.after(:all) do
    FakeFS::FileSystem.clear
    FakeFS.deactivate!
  end
end
