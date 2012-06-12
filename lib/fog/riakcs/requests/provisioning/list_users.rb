module Fog
  module RiakCS
    class Provisioning
      class Real
        include Utils
        include MultipartUtils

        def list_users(options = {})
          response      = @s3_connection.get_object('riak-cs', 'users', { 'Accept' => 'application/json', 'query' => options })

          boundary      = extract_boundary(response.headers['Content-Type'])
          parts         = parse(response.body, boundary)
          decoded       = parts.map { |part| MultiJson.decode(part[:body]) }

          response.body = decoded.flatten

          response
        end
      end

      class Mock
        def list_users(options = {})
          filtered_data = options[:disabled] ? data : data.reject { |key, value| value[:status] == 'disabled' }

          Excon::Response.new.tap do |response|
            response.status = 200
            response.body   = filtered_data.map do |key, value|
              {
                "Email"       => value[:email],
                "DisplayName" => value[:name],
                "Name"        => "user123",
                "KeyId"       => key,
                "KeySecret"   => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX==",
                "Id"          => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
              }
            end.compact
          end
        end
      end
    end
  end
end
