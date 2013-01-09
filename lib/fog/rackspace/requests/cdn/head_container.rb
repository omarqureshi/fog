module Fog
  module CDN
    class Rackspace
      class Mock
        def head_container(container)
          response = Excon::Response.new
          response.status = 204
          response.headers = {
            'X-CDN-Enabled' => true,
            'X-CDN-URI' => "http://081e40d3ee1cec5f77bf-346eb45fd42c58ca13011d659bfc1ac1.r49.cf0.rackcdn.com",
            'X-TTL' => 123,
            'X-Log-Retention' => false
          }
          response
        end
      end

      class Real

        # List cdn properties for a container
        #
        # ==== Parameters
        # * container<~String> - Name of container to retrieve info for
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * headers<~Hash>:
        #     * 'X-CDN-Enabled'<~Boolean> - cdn status for container
        #     * 'X-CDN-URI'<~String> - cdn url for this container
        #     * 'X-TTL'<~String> - integer seconds before data expires, defaults to 86400 (1 day)
        #     * 'X-Log-Retention'<~Boolean> - ?
        #     * 'X-User-Agent-ACL'<~String> - ?
        #     * 'X-Referrer-ACL'<~String> - ?
        def head_container(container)
          response = request(
            :expects  => 204,
            :method   => 'HEAD',
            :path     => container,
            :query    => {'format' => 'json'}
          )
          response
        end

      end
    end
  end
end
