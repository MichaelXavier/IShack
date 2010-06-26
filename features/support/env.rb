$LOAD_PATH << 'lib'
require 'ishack'
require 'fakeweb'
require 'rr'
require 'fakefs/safe'

World do
  extend RR::Adapters::RRMethods
end

Before do
  FakeWeb.clean_registry
  FakeWeb.register_uri(:post, 
                       IShack::Uploader.api_uri, 
                       :body   => "<image_link>http://imageshack.us/link/to/image.jpg</image_link>",
                       :status => ["200"])
  FakeFS.activate!
end

After do
  FakeFS::FileSystem.clear
  FakeFS.deactivate!
end

