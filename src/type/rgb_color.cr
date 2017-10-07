
module Style

  struct RGB_Color

    @first  : RGB_Level
    @second : RGB_Level
    @third  : RGB_Level

    def initialize(@first : RGB_Level, @second : RGB_Level, @third : RGB_Level)
    end # === def initialize

    def initialize(first : Int32, second : Int32, third : Int32)
      @first  = RGB_Level.new(first)
      @second = RGB_Level.new(second)
      @third  = RGB_Level.new(third)
    end # === def initialize

    def to_css
      "rgb(#{@first.to_css}, #{@second.to_css}, #{@third.to_css})"
    end

  end # === struct RGB_Color

  def rgb(*args)
    RGB_Color.new(*args)
  end # === def rgb

end # === module Style
