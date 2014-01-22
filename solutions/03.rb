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
      BresenhamAlgorithm.new(from.x, from.y, to.x, to.y).draw_on(canvas)
    end

    def reach_last?
      @current_x == to.x and @current_y == to.y
    end
  end
  
  class BresenhamAlgorithm
    def initialize(from_x, from_y, to_x, to_y)
      @from_x, @from_y = from_x, from_y
      @to_x, @to_y     = to_x, to_y
    end

    def rasterize_on(canvas)
      initialize_from_and_to_coordinates
      rotate_coordinates_by_ninety_degrees if steep_slope?
      swap_from_and_to if @drawing_from_x > @drawing_to_x

      draw_line_pixels_on canvas
    end

    def steep_slope?
      (@to_y - @from_y).abs > (@to_x - @from_x).abs
    end

    def initialize_from_and_to_coordinates
      @drawing_from_x, @drawing_from_y = @from_x, @from_y
      @drawing_to_x, @drawing_to_y     = @to_x, @to_y
    end

    def rotate_coordinates_by_ninety_degrees
      @drawing_from_x, @drawing_from_y = @drawing_from_y, @drawing_from_x
      @drawing_to_x, @drawing_to_y     = @drawing_to_y, @drawing_to_x
    end

    def swap_from_and_to
      @drawing_from_x, @drawing_to_x = @drawing_to_x, @drawing_from_x
      @drawing_from_y, @drawing_to_y = @drawing_to_y, @drawing_from_y
    end

    def error_delta
      delta_x = @drawing_to_x - @drawing_from_x
      delta_y = (@drawing_to_y - @drawing_from_y).abs

      delta_y.to_f / delta_x
    end

    def vertical_drawing_direction
      @drawing_from_y < @drawing_to_y ? 1 : -1
    end

    def draw_line_pixels_on(canvas)
      @error = 0.0
      @y     = @drawing_from_y

      @drawing_from_x.upto(@drawing_to_x).each do |x|
        set_pixel_on canvas, x, @y
        calculate_next_y_approximation
      end
    end

    def calculate_next_y_approximation
      @error += error_delta

      if @error >= 0.5
        @error -= 1.0
        @y += vertical_drawing_direction
      end
    end

    def set_pixel_on(canvas, x, y)
      if steep_slope?
        canvas.set_pixel y, x
      else
        canvas.set_pixel x, y
      end
    end
  end

  class Rectangle
    attr_reader :first_vertex, :second_vertex

    def initialize(one_vertex, other_vertex)
      @first_vertex  = one_vertex
      @second_vertex = other_vertex
    end

    def left
      if @first_vertex.x == @second_vertex.x
        @first_vertex.y <= @second_vertex.y ? @first_vertex : @second_vertex
      else
        @first_vertex.x <= @second_vertex.x ? @first_vertex : @second_vertex
      end
    end

    def right
      if @first_vertex.x == @second_vertex.x
        @first_vertex.y <= @second_vertex.y ? @second_vertex : @first_vertex
      else
        @first_vertex.x <= @second_vertex.x ? @second_vertex : @first_vertex
      end
    end

    def draw_on(canvas)
      canvas.draw (Line.new(top_left, top_right))
      canvas.draw (Line.new(top_left, bottom_left))
      canvas.draw (Line.new(bottom_left, bottom_right))
      canvas.draw (Line.new(top_right, bottom_right))
    end

    def top_left
      Point.new left.x,  [left.y, right.y].min
    end

    def top_right
      Point.new right.x, [left.y, right.y].min
    end

    def bottom_right
      Point.new right.x, [left.y, right.y].max
    end

    def bottom_left
      Point.new left.x,  [left.y, right.y].max
    end

    def == (other)
      top_left == other.top_left and bottom_right == other.bottom_right
    end

    alias eql? ==

    def hash
      [top_left, bottom_right].hash
    end
  end
end