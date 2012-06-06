module Fog
  module RiakCS
    class Provisioning 
      class Real
        include Utils
        include MultipartUtils

        def get_user(key_id)
          response = @s3_connection.get_object('riak-cs', "user/#{key_id}", { 'Accept' => 'application/json' })
          response.body = MultiJson.decode(response.body)
          response
        end
      end

      class Mock
        def get_user(email)
          if name = data[:provisioning][email]
            Excon::Response.new.tap do |response|
              response.status = 200
              response.headers['Content-Type'] = 'application/json'
              response.body = {
                "Email"       => email,
                "DisplayName" => name,
                "Name"        => "user123",
                "KeyId"       => "XXXXXXXXXXXXXXXXXXXX",
                "KeySecret"   => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX==",
                "Id"          => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
              }
            end
          else
            Excon::Response.new.tap do |response|
              response.status = 404
              response.headers['Content-Type'] = 'application/json'
            end
          end
        end
      end
    end
  end
end
