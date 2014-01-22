module Graphics
  class Point
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def draw_on(canvas)
      canvas.set_pixel(x,y)
    end

    def == (other)
      x == other.x and y == other.y
    end

    alias eql? ==

    def hash
      [x, y].hash
    end
  end
end