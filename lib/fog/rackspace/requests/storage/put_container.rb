module Fog
  module Storage
    class Rackspace
      class Mock
        def put_container(name)
          response = Excon::Response.new
          response.status = 201
          response
        end
      end
      
      class Real

        # Create a new container
        #
        # ==== Parameters
        # * name<~String> - Name for container, should be < 256 bytes and must not contain '/'
        #
        def put_container(name)
          request(
            :expects  => [201, 202],
            :method   => 'PUT',
            :path     => Fog::Rackspace.escape(name)
          )
        end

      end
    end
  end
end
