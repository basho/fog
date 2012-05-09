Shindo.tests('RiakCS::Provisioning | provisioning requests', ['riakcs']) do

  current_timestamp = Time.now.to_i

  tests('Successful user creation') do

    @user_format = {
      'Email'       => String,
      'DisplayName' => String,
      'Name'        => String,
      'KeyId'       => String,
      'KeySecret'   => String,
      'Id'          => String,
    }

    tests("#create_user('user@example.com', 'Fog User')").formats(@user_format) do
      Fog::RiakCS[:provisioning].create_user("user#{current_timestamp unless Fog.mocking?}@example.com", 'Fog User').body
    end

  end

  tests('User listing') do 

    tests('retrieve a user listing').formats(@user_format) do 
      unless Fog.mocking?
        Fog::RiakCS[:provisioning].create_user("existing#{current_timestamp}@example.com", 'Fog User')
      end

      Fog::RiakCS[:provisioning].list_users.body.first
    end

  end

  tests('Duplicate user creation failure') do

    tests("#create_user('existing@example.com', 'Fog User')").raises(Fog::RiakCS::Provisioning::UserAlreadyExists) do
      if Fog.mocking?
        Fog::RiakCS[:provisioning].create_user("existing@example.com", 'Fog User')
      else
        2.times do 
          Fog::RiakCS[:provisioning].create_user("existing#{current_timestamp}@example.com", 'Fog User')
        end
      end
    end

  end

end
