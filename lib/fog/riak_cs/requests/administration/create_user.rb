module Fog
  module RiakCS
    class Administration 
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
            raise Fog::RiakCS::Administration::UserAlreadyExists, "User with email #{email} already exists."
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
