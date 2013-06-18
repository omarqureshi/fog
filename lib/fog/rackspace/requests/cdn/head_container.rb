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
        # @return [Excon::Response] response
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
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
      
      class Mock
        
        def head_container(container)
          raise Fog::Storage::Rackspace::NotFound.new "#{container} not found" unless container == 'fogcontainertests'
          response = Excon::Response.new
          response.status = 204
          response.headers = { 
            "X-Cdn-Uri"=>"http://e4bbc22477d80eaf22bd-ca4e4e61e477bbd430e1f5b9dc9a19f5.r53.cf1.rackcdn.com", 
            "X-Cdn-Ios-Uri"=>"http://3c10ef49037f74416445-ca4e4e61e477bbd430e1f5b9dc9a19f5.iosr.cf1.rackcdn.com", 
            "X-Cdn-Ssl-Uri"=>"https://b722b8ee248259c37901-ca4e4e61e477bbd430e1f5b9dc9a19f5.ssl.cf1.rackcdn.com", 
            "X-Log-Retention"=>"False", 
            "X-Cdn-Enabled"=>"True", 
            "Content-Length"=>"0", 
            "Date"=>"Fri, 01 Feb 2013 21:25:57 GMT", 
            "X-Cdn-Streaming-Uri"=>"http://b82027c64cb4dd03670a-ca4e4e61e477bbd430e1f5b9dc9a19f5.r53.stream.cf1.rackcdn.com", 
            "X-Ttl"=>"259200", 
            "X-Trans-Id"=>"txca40ffd0412943608bb3e9656c8b81ef"
          }             
          response.body = "" 
          response
        end        
      end
      
    end
  end
end
