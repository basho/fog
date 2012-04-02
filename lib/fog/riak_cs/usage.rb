require File.expand_path(File.join(File.dirname(__FILE__), '..', 'riak_cs'))
require 'time'

module Fog
  module RiakCS
    class Usage < Fog::Service

      requires :riak_cs_access_key_id, :riak_cs_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent

      request_path 'fog/riak_cs/requests/usage'
      request :get_usage

      class Mock
        include Fog::RiakCS::Utils

        def self.data
          @data ||= Hash.new do |hash, key| 
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options = {}) 
          configure_uri_options(options)
        end

        def data
          self.class.data[riak_cs_uri]
        end

        def reset_data
          self.class.data.delete(riak_cs_uri)
        end
      end

      class Real
        include Fog::RiakCS::Utils

        def initialize(options = {})
          require 'mime/types'
          require 'multi_json'
          require 'multi_xml'

          configure_uri_options(options)
          @riak_cs_access_key_id     = options[:riak_cs_access_key_id]
          @riak_cs_secret_access_key = options[:riak_cs_secret_access_key]
          @connection_options        = options[:connection_options] || {}
          @persistent                = options[:persistent]         || false

          @connection = Fog::Storage.new(
            :provider              => 'AWS',
            :aws_access_key_id     => @riak_cs_access_key_id,
            :aws_secret_access_key => @riak_cs_secret_access_key,
            :host                  => @host,
            :port                  => @port,
            :scheme                => @scheme
          )
        end
      end

    end
  end
end
