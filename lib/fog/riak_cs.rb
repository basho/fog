require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module RiakCS

    extend Fog::Provider 

    service(:administration, 'riak_cs/administration', 'Administration')

  end
end
