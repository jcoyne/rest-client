module RestClient

  # A Response from RestClient, you can access the response body, the code or the headers.
  #
  module Response

    include AbstractResponse

    attr_accessor :args, :body, :net_http_res

    def body
      self
    end

    def Response.create body, net_http_res, args
      result = encoded_body(body, net_http_res)
      result.extend Response
      result.net_http_res = net_http_res
      result.args = args
      result
    end


    private

    def self.encoded_body(body, net_http_res)
      result = body || ''
      if ((200..207).include?(net_http_res.code.to_i) && content_type = net_http_res.content_type)
        charset = if set = net_http_res.type_params['charset'] 
          set
        elsif content_type == 'text/xml'
          'us-ascii'
        elsif content_type.split('/').first == 'text'
          'iso-8859-1'
        end
        result.force_encoding(charset) if charset
      end
      result
    end

  end
end
