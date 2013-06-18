module Fog
  module Storage
    class Rackspace

      class Mock
        def put_object(container, object, data, options = {})
          data = Fog::Storage.parse_data(data)
          data[:body] = data[:body].read unless data[:body].is_a?(String)
          response = Excon::Response.new
          response.status = 201
          object = {
            :body             => data[:body],
            'Content-Type'    => options['Content-Type'] || data[:headers]['Content-Type'],
            'ETag'            => Digest::MD5.hexdigest(data[:body]),
            'Last-Modified'   => Fog::Time.now.to_date_header,
            'Content-Length'  => options['Content-Length'] || data[:headers]['Content-Length'],
          }

          response.headers = {
            'Content-Length'   => object['Content-Length'],
            'Content-Type'     => object['Content-Type'],
            'ETag'             => object['ETag'],
            'Last-Modified'    => object['Last-Modified'],
          }
          response
        end
      end


      class Real

        # Create a new object
        #
        # ==== Parameters
        # * container<~String> - Name for container, should be < 256 bytes and must not contain '/'
        # * object<~String> - Name for object
        # * data<~String|File> - data to upload
        # * options<~Hash> - config headers for object. Defaults to {}.
        # @raise [Fog::Storage::Rackspace::NotFound] - HTTP 404
        # @raise [Fog::Storage::Rackspace::BadRequest] - HTTP 400
        # @raise [Fog::Storage::Rackspace::InternalServerError] - HTTP 500
        # @raise [Fog::Storage::Rackspace::ServiceError]
        def put_object(container, object, data, options = {}, &block)
          data = Fog::Storage.parse_data(data)
          headers = data[:headers].merge!(options)

          params = block_given? ? { :request_block => block } : { :body => data[:body] }

          params.merge!(
            :expects    => 201,
            :idempotent => true,
            :headers    => headers,
            :method     => 'PUT',
            :path       => "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          )

          request(params)
        end
      end
    end
  end
end
