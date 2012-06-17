module Fog
  module RiakCS
    class Provisioning
      class Real
        def create_user(email, name)
          request(
            :expects  => [201],
            :method   => 'POST',
            :path     => 'user',
            :body     => MultiJson.encode({ :email => email, :name => name }),
            :headers  => { 'Content-Type' => 'application/json' }
          )
        end
      end

      class Mock
        def invalid_email?(email)
          !email.include?('@')
        end

        def user_exists?(email)
          data.detect do |key, value|
            value[:email] == email
          end
        end

        def create_user(email, name)
          if invalid_email?(email)
            raise Fog::RiakCS::Provisioning::ServiceUnavailable, "The email address you provided is not a valid."
          end

          if user_exists?(email)
            raise Fog::RiakCS::Provisioning::UserAlreadyExists, "User with email #{email} already exists."
          end

          key_id       = rand(1000).to_s
          key_secret   = rand(1000).to_s
          data[key_id] = { :email => email, :name => name, :status => 'enabled', :key_secret => key_secret }

          Excon::Response.new.tap do |response|
            response.status = 200
            response.headers['Content-Type'] = 'application/json'
            response.body = {
              "email"        => data[:email],
              "display_name" => data[:name],
              "name"         => "user123",
              "key_id"       => key_id,
              "key_secret"   => key_secret,
              "id"           => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
              "status"       => "enabled"
            }
          end
        end
      end
    end
  end
end
