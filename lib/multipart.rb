require 'cgi'
require 'mime/types'

module Multipart
  class Post
    #BOUNDARY     =  "----RubyMultipartBoundary#{rand(1000000)}ZZZZZ"
    BOUNDARY         = "ZZZZZ-RubyMultipartBoundary#{rand(1000000)}-ZZZZZ"
    HEADER           = {"Content-Type" => "multipart/form-data"}
    HEADER_WITH_FILE = {"Content-Type" => "multipart/form-data; boundary=#{ BOUNDARY }"}

    class << self
      def prepare_query(params)
        if params.any? {|k, v| v.is_a? File}
          ret = params.collect {|k, v|
                  key  = k.to_s 
                  data = v.is_a?(File) ? file_to_multipart(key, v) : str_to_multipart(key, v)
                  "--#{BOUNDARY}\r\n#{data}" 
                }.join + "--#{BOUNDARY}--"
          header = HEADER_WITH_FILE
        else
          ret = hash_to_query(params)
          header = HEADER
        end
        return ret, header
      end

      def hash_to_query(h)
        h.collect {|k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.join('&')
      end

    private

      def str_to_multipart(k, str)
        "Content-Disposition: form-data; name=\"#{CGI::escape(k)}\"\r\n\r\n#{str}\r\n"
      end

      def file_to_multipart(k, file)
        "Content-Disposition: form-data; name=\"#{CGI::escape(k)}\"; filename=\"#{file.path}\"\r\nContent-Type: #{file_mime_type(file.path).simplified}\r\n\r\n#{file.read}\r\n"
      end

      def file_mime_type(filename)
        MIME::Types.type_for(filename)[0] || MIME::Types["application/octet-stream"][0]
      end
    end
  end
end
