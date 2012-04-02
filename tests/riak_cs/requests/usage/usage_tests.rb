Shindo.tests('RiakCS::Usage | usage requests', ['riak_cs']) do

  @blank_usage_format = {
    'Access' => [
      { 
        'Errors' => [] 
      }
    ],
    'Storage' => [
      { 
        'Errors' => [] 
      }
    ]
  }

  tests('Statistics retrieval with no data returned') do 

    start_time = Time.now.utc + 86400
    end_time   = start_time   + 86400

    tests('via JSON').returns(@blank_usage_format) do

      Fog::RiakCS[:usage].get_usage('G5RXHUKDPFS7_HC1C8EL',
                                    :format     => :json,
                                    :types      => [:access, :storage],
                                    :start_time => start_time,
                                    :end_time   => end_time).body

    end
  end

end
