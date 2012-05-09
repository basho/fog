module Fog
  module RiakCS
    class Provisioning 
      class Real
        include Utils
        include MultipartUtils

        def list_users
          response = @s3_connection.get_object('riak-cs', 'users', { 'Accept' => 'application/json' })

          boundary      = extract_boundary(response.headers['Content-Type'])
          parts         = parse(response.body, boundary)
          decoded       = parts.map { |part| MultiJson.decode(part[:body]) }

          response.body = decoded.flatten

          response
        end
      end

      class Mock
        def list_users
          Excon::Response.new.tap do |response|
            response.status = 200
            response.body = [{
              "Email"       => 'email@email.com',
              "DisplayName" => 'user',
              "Name"        => "user123",
              "KeyId"       => "XXXXXXXXXXXXXXXXXXXX",
              "KeySecret"   => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX==",
              "Id"          => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            }]
          end
        end
      end
    end
  end
end
