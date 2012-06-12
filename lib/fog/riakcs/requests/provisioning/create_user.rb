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
          data[key_id] = { :email => email, :name => name, :status => 'enabled' }

          Excon::Response.new.tap do |response|
            response.status = 200
            response.headers['Content-Type'] = 'application/json'
            response.body = {
              "Email"       => data[:email],
              "DisplayName" => data[:name],
              "Name"        => "user123",
              "KeyId"       => key_id,
              "KeySecret"   => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX==",
              "Id"          => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
            }
          end
        end
      end
    end
  end
end
