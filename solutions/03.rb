module Graphics
  class Canvas
    attr_reader :width, :height, :pixels

    def initialize(width, height)
      @height = height
      @width  = width
      @pixels = {}
    end

    def set_pixel(x, y)
      @pixels["#{x},#{y}"] = true
    end

    def pixel_at?(x, y)
      @pixels.has_key?("#{x},#{y}")
    end

    def draw(geometric_object)
      geometric_object.draw_on(self)
    end

    def render_as(argument)
      argument.render(self)
    end
  end

  module Renderers
    class Ascii
      attr_reader :ascii_text

      def self.render(canvas)
        @ascii_text = ''
        0.upto(canvas.height).each do |row|
          0.upto(canvas.width).each do |column|
            set_character(canvas, column, row)
          end
        @ascii_text << "\n"
        end
        @ascii_text
      end

      private

      def self.set_character(canvas, x, y)
        canvas.pixel_at?(x, y) ? @ascii_text << '@' : @ascii_text << '-'
      end
    end

    class Html
      attr_reader :html_body

      HEADER =
     '<!DOCTYPE html>
      <html>
      <head>
        <title>Rendered Canvas</title>
        <style type="text/css">
          .canvas {
            font-size: 1px;
            line-height: 1px;
          }
          .canvas * {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 5px;
          }
          .canvas i {
            background-color: #eee;
          }
          .canvas b {
            background-color: #333;
          }
        </style>
      </head>
      <body>
        <div class="canvas">'

      FOOTER =
      ' </div>
      </body>
      </html>'

      def self.render(canvas)
        @html_body = ''

        0.upto(canvas.height).each do |row|
          0.upto(canvas.width).each do |column|
            set_character(canvas, column, row)
          end
        @html_body << '<br>'
        end
        HEADER + @html_body + FOOTER
      end

      private

      def self.set_character(canvas, x, y)
        canvas.pixel_at?(x, y) ? @html_body << '<b></b>' : @html_body << '<i></i>'
      end
    end
  end

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
      self.x == other.x and self.y == other.y
    end

    def eql?(other)
      self.hash.eql?(other.hash)
    end

    def hash
      "X#{x}Y#{y}"
    end
  end

  class Line
    attr_reader :first_point, :second_point, :current_x, :current_y

    def initialize(first_point, second_point)
      @first_point  = first_point
      @second_point = second_point
      @error        = (to.x - from.x).abs - (to.y - from.y).abs
    end

    def from
      if @first_point.x == @second_point.x
        @first_point.y <= @second_point.y ? @first_point : @second_point
      else
        @first_point.x <= @second_point.x ? @first_point : @second_point
      end
    end

    def to
      if @first_point.x == @second_point.x
        @first_point.y <= @second_point.y ? @second_point : @first_point
      else
        @first_point.x <= @second_point.x ? @second_point : @first_point
      end
    end

    def draw_on(canvas)
      @current_x = from.x
      @current_y = from.y
      draw_line(canvas)
    end

    def == (other)
      self.from == other.from and self.to == other.to
    end

    def eql?(other)
      self.hash.eql?(other.hash)
    end

    def hash
      "FX#{from.x}FY#{from.y}TX#{to.x}TY#{to.y}"
    end

    private

    def draw_line(canvas)
      while true
        canvas.set_pixel(@current_x, @current_y)

        break if reach_last?

        compute_next_x

        canvas.set_pixel(@current_x, @current_y) if reach_last?

        compute_next_y
      end
    end

    def reach_last?
      @current_x == to.x and @current_y == to.y
    end

    def compute_next_x
      if (2 * @error >= -(to.y - from.y).abs)
        @error -= (to.y - from.y).abs
        from.x < to.x ? @current_x += 1 : @current_y -= 1
      end
    end

    def compute_next_y
      if (2 * @error < (to.x - from.x).abs)
        @error += (to.x - from.x).abs
        from.y < to.y ? @current_y += 1 : @current_y -= 1
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

    def top_left
      x_coordinate = [@first_vertex.x, @second_vertex.x].min
      y_coordinate = [@first_vertex.y, @second_vertex.y].min
      Point.new(x_coordinate, y_coordinate)
    end

    def top_right
      x_coordinate = [@first_vertex.x, @second_vertex.x].max
      y_coordinate = [@first_vertex.y, @second_vertex.y].min
      Point.new(x_coordinate, y_coordinate)
    end

    def bottom_left
      x_coordinate = [@first_vertex.x, @second_vertex.x].min
      y_coordinate = [@first_vertex.y, @second_vertex.y].max
      Point.new(x_coordinate, y_coordinate)
    end

    def bottom_right
      x_coordinate = [@first_vertex.x, @second_vertex.x].max
      y_coordinate = [@first_vertex.y, @second_vertex.y].max
      Point.new(x_coordinate, y_coordinate)
    end

    def == (other)
      self.top_left == other.top_left and self.bottom_right == other.bottom_right
    end

    def eql?(other)
      self.hash.eql?(other.hash)
    end

    def hash
      x = top_left.x
      y = top_left.y
      width = (@first_vertex.x - @second_vertex.x).abs
      height = (@first_vertex.y - @second_vertex.y).abs

      "X#{x}Y#{y}W#{width}H#{height}"
    end

    def draw_on(canvas)
      canvas.draw (Line.new(top_left, top_right))
      canvas.draw (Line.new(top_left, bottom_left))
      canvas.draw (Line.new(bottom_left, bottom_right))
      canvas.draw (Line.new(top_right, bottom_right))
    end
  end
end