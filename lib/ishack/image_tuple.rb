module IShack
  class ImageTuple
    attr_reader :origin, :link
    def initialize(origin, link)
      @origin, @link = origin, link
    end
  end
end
