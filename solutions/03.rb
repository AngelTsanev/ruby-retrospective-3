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
  end
end