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
        #
        def put_object(container, object, data, options = {})
          data = Fog::Storage.parse_data(data)
          headers = data[:headers].merge!(options)
          request(
            :body       => data[:body],
            :expects    => 201,
            :idempotent => true,
            :headers    => headers,
            :method     => 'PUT',
            :path       => "#{Fog::Rackspace.escape(container)}/#{Fog::Rackspace.escape(object)}"
          )
        end

      end
    end
  end
end
