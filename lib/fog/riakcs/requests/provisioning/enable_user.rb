module Fog
  module RiakCS
    class Provisioning
      class Real
        include Utils
        include MultipartUtils

        def enable_user(key_id)
          response = @s3_connection.put_object('riak-cs', "user/#{key_id}", MultiJson.encode({ :status => 'enabled' }), { 'Content-Type' => 'application/json' })
          if !response.body.empty?
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

      class Mock
        def enable_user(key_id)
          if user = data[key_id]
            data[key_id][:status] = "enabled"

            Excon::Response.new.tap do |response|
              response.status = 200
              response.body   = nil
            end
          else
            Excon::Response.new.tap do |response|
              response.status = 403
            end
          end
        end
      end
    end
  end
end
