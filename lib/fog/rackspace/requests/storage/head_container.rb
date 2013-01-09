module Fog
  module Storage
    class Rackspace
 
      class Mock
        def head_container(container)
          response = Excon::Response.new
          response.status = 204          
          response.headers = {
            'X-Container-Object-Count' => 1,
            'X-Container-Bytes-Used' => 123
          }
          response
        end
      end

      class Real

        # List number of objects and total bytes stored
        #
        # ==== Parameters
        # * container<~String> - Name of container to retrieve info for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-Container-Object-Count'<~String> - Count of containers
        #     * 'X-Container-Bytes-Used'<~String>   - Bytes used
        def head_container(container)
          request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => Fog::Rackspace.escape(container),
            :query    => {'format' => 'json'}
          )
        end

      end
    end
  end
end
