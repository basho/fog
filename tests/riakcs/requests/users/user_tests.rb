Shindo.tests('RiakCS::Users | user requests', ['riakcs']) do

  current_timestamp = Time.now.to_i

  tests('Successful user creation') do

    @user_format = {
      'email'        => String,
      'display_name' => String,
      'name'         => String,
      'key_id'       => String,
      'key_secret'   => String,
      'id'           => String,
    }

    tests("#create_user('user@example.com', 'Fog User')").formats(@user_format) do
      Fog::RiakCS[:users].create_user("user#{current_timestamp unless Fog.mocking?}@example.com", 'Fog User').body
    end

  end

  tests('Duplicate user creation failure') do

    tests("#create_user('existing@example.com', 'Fog User')").raises(Fog::RiakCS::Users::UserAlreadyExists) do
      if Fog.mocking?
        Fog::RiakCS[:users].create_user("existing@example.com", 'Fog User')
      else
        2.times do 
          Fog::RiakCS[:users].create_user("existing#{current_timestamp}@example.com", 'Fog User')
        end
      end
    end

  end

end
