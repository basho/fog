module Fog
  module RiakCS
    class Provisioning 
      class Real
        def create_user(email, name)
          request(
            :expects  => [200],
            :method   => 'POST', 
            :path     => 'user',
            :body     => "email=#{email}&name=#{name}"
          )
        end
      end

      class Mock
        def create_user(email, name) 
          if data[:provisioning].has_key? email
            raise Fog::RiakCS::Provisioning::UserAlreadyExists, "User with email #{email} already exists."
            {}
          else
            data[:provisioning][email] = name
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
          end
        end
      end
    end
  end
end
