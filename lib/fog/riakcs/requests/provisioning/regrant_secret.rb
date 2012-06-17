module Fog
  module RiakCS
    class Provisioning
      class Real
        include Utils
        include MultipartUtils

        def regrant_secret(key_id)
          response = @s3_connection.put_object('riak-cs', "user/#{key_id}", MultiJson.encode({ :new_key_secret => true }), { 'Content-Type' => 'application/json' })
          response
        end
      end

      class Mock
        def regrant_secret(key_id)
          if user = data[key_id]
            data[key_id][:key_secret] = rand(100).to_s

            Excon::Response.new.tap do |response|
              response.status = 204
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
