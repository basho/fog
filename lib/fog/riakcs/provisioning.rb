require File.expand_path(File.join(File.dirname(__FILE__), '..', 'riakcs'))

module Fog
  module RiakCS
    class Provisioning < Fog::Service

      class UserAlreadyExists < Fog::RiakCS::Provisioning::Error; end

      recognizes :host, :path, :port, :scheme, :persistent

      request_path 'fog/riakcs/requests/provisioning'
      request :create_user 

      class Mock
        include Utils

        def self.data
          @data ||= Hash.new do |hash, key| 
            hash[key] = {
              :provisioning => {
                "existing@example.com" => "Preexisting user"
              }
            }
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options = {}) 
          configure_uri_options(options)
        end

        def data
          self.class.data[riakcs_uri]
        end

        def reset_data
          self.class.data.delete(riakcs_uri)
        end
      end

      class Real
        include Utils

        def initialize(options = {})
          require 'mime/types'
          require 'multi_json'
          require 'multi_xml'

          configure_uri_options(options)
          @connection_options = options[:connection_options] || {}
          @persistent         = options[:persistent]         || false

          @connection = Fog::Connection.new(riakcs_uri, @persistent, @connection_options)
        end

        def request(params, parse_response = true, &block) 
          begin
            response = @connection.request(params.merge!({
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}",
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            if match = error.message.match(/<Code>(.*)<\/Code>(?:.*<Message>(.*)<\/Message>)?/m)
              case match[1]
              when 'UserAlreadyExists'
                raise Fog::RiakCS::Provisioning.const_get(match[1]).new
              else
                raise error
              end
            end
          end
          if !response.body.empty? && parse_response
            case response.headers['Content-Type']
            when 'application/json'
              response.body = MultiJson.decode(response.body)
            when 'application/xml'
              response.body = MultiXml.parse(response.body)
            end
          end
          response
        end
      end

    end
  end
end
