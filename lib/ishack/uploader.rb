require 'uri'
require 'net/http'
require 'progressbar'
require 'multipart'
require 'nokogiri'

require 'ishack/image_tuple'

module IShack
  class ImageshackError < RuntimeError; end

  class Uploader
    attr_accessor :output

    class << self
      def api_uri
        URI.parse('http://www.imageshack.us/upload_api.php')
      end
    end

    def initialize(options={})
      validate_options(options)
      parse_items(options)

      @key      = options[:key]
      @progress = options[:progress]
      @links    = []
      @output   = $stdout
    end

    def run
      pbar = ProgressBar.new("Progress", @items.length, @output) if @progress

      @items.each do |i| 
        begin
          @mode == :transload ? transload(i) : upload(i)
        rescue ImageshackError
          warn "Warning: got a bad status back on #{@mode} #{i.to_s}"
        end
        pbar.inc if @progress
      end

      display_results
    end

  private

    def parse_items(options)
      @mode  = options[:transload] ? :transload : :upload
      @items = options[:items]
      @items.collect! {|i| URI.parse(i)} if @mode == :transload
    end

    def upload(filename)
      file = File.open(filename, 'rb')
      query, headers = Multipart::Post.prepare_query(:key => @key, :fileupload => file)
      http = Net::HTTP.new(IShack::Uploader.api_uri.host)

      begin
        link = parse_result(http.post(IShack::Uploader.api_uri.path, query, headers))
        @links << ImageTuple.new(filename, link)
      ensure
        file.close
      end
    end

    def transload(uri)
      link = parse_result(Net::HTTP.post_form(IShack::Uploader.api_uri, {:key => @key, :url => uri.to_s}))
      @links << ImageTuple.new(uri.to_s, link)
    end

    def parse_result(res)
      if res.is_a? Net::HTTPSuccess or res.is_a? Net::HTTPRedirection
        doc = Nokogiri::XML(res.body)
        if link = doc.at('image_link')
          return link.text
        end
      end

      raise ImageshackError
    end

    def validate_options(options)
      raise ArgumentError, "Must have at least 1 item to upload." if options[:items].empty? 
      raise ArgumentError, "Must specify an API key." unless options[:key] and !options[:key].empty?

      unless options[:transload]
        options[:items].each do |f|
          raise ArgumentError, "File #{f} does not exist." unless File.exists? f
        end
      end
    end

    def display_results
      max_width   = (get_cols or 80)
      mid         = 6
      right_width = @links.collect {|l| l.link.to_s.length}.max
      left_width  = max_width - right_width - mid - 1
      left_width  = right_width if left_width <= 0 #if there's no room, screw it, just wrap

      @links.each do |link|
        @output.puts "#{link.origin[0...left_width].rjust(left_width)}:#{" ".center(mid, " ")}#{link.link.ljust(right_width)}"
      end
    end

    def hash_to_query(h)
      h.collect {|k,v| "#{CGI::escape(k)}=#{CGI::escape(k)}"}.join('&')
    end

    def get_cols
      output = %x(tput cols).chomp
      output.empty? ? nil : output.to_i
    end
  end
end
