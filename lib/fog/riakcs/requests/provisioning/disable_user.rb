module Fog
  module RiakCS
    class Provisioning
      class Real
        include Utils
        include MultipartUtils

        def disable_user(key_id)
          @s3_connection.put_object('riak-cs', "user/#{key_id}", MultiJson.encode({ :status => 'disabled' }), { 'Content-Type' => 'application/json' })
        end
      end

      class Mock
        def disable_user(key_id)
          if user = data[key_id]
            data[key_id][:status] = "disabled"

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
