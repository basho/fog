class RiakCS < Fog::Bin
  class << self

    def class_for(key)
      case key
      when :users
        Fog::RiakCS::Users
      else
        raise ArgumentError, "Unrecognized service: #{key}"
      end
    end

    def [](service)
      @@connections ||= Hash.new do |hash, key|
        hash[key] = case key
        when :users
          Fog::RiakCS::Users
        else
          raise ArgumentError, "Unrecognized service: #{key.inspect}"
        end
      end
      @@connections[service]
    end

    def services
      Fog::RiakCS.services
    end

  end
end
