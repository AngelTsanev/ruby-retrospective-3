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

    def == (other_point)
      x == other_point.x and y == other_point.y
    end

    alias eql? ==

    def hash
      [x, y].hash
    end
  end

  class Line
    attr_reader :from, :to

    def initialize(from, to)
      if (from.x == to.x and from.y > to. y) or from.x > to.x
        @from = to
        @to   = from
      else
        @from = from
        @to   = to
      end
    end

    def draw_on(canvas)
      @current_x = from.x
      @current_y = from.y
      draw_line(canvas)
    end

    def == (other_line)
      from == other_line.from and to == other_line.to
    end

    alias eql? ==
    
    def hash
      [from.hash, to.hash].hash
    end

    private

    def draw_line(canvas)
      #BresenhamAlgorithm.new(from.x, from.y, to.x, to.y).draw_on(canvas)
    end

    def reach_last?
      @current_x == to.x and @current_y == to.y
    end
  end
end