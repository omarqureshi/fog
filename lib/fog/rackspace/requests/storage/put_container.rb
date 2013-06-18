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
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def put_container(name, options={})
          request(
            :expects  => [201, 202],
            :method   => 'PUT',
            :headers => options,
            :path     => Fog::Rackspace.escape(name)
          )
        end

      end
    end
  end
end
