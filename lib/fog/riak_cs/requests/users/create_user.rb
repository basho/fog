module Fog
  module RiakCS
    class Users 
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
          if data[:users].has_key? email
            raise Fog::RiakCS::Users::UserAlreadyExists, "User with email #{email} already exists."
            {}
          else
            data[:users][email] = name
            Excon::Response.new.tap do |response|
              response.status = 200
              response.headers['Content-Type'] = 'application/json'
              response.body = {
                "email"        => email,
                "display_name" => name,
                "name"         => "user123",
                "key_id"       => "XXXXXXXXXXXXXXXXXXXX",
                "key_secret"   => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX==",
                "id"           => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
              }
            end
          end
        end
      end
    end
  end
end
