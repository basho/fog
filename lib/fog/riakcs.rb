require(File.expand_path(File.join(File.dirname(__FILE__), 'core')))

module Fog
  module RiakCS

    module Utils
      def configure_uri_options(options = {})
        @host       = options[:host]       || 'localhost'
        @persistent = options[:persistent] || true
        @port       = options[:port]       || 8080
        @scheme     = options[:scheme]     || 'http'
      end

      def riakcs_uri
        "#{@scheme}://#{@host}:#{@port}"
      end
    end

    extend Fog::Provider 

    service(:provisioning, 'riakcs/provisioning', 'Provisioning')
    service(:usage,        'riakcs/usage',        'Usage')

  end
end
