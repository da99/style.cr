
require "./helpers/positive_negative"

require "./type/url_image"

require "./keyword/keyword"

require "./type/percent"
require "./type/px"
require "./type/em"
require "./type/color"
require "./type/linear_gradient"
require "./type/int32"
require "./type/angle_degree"
require "./type/float64"

require "./property/background"
require "./property/border"
require "./property/width"
require "./property/float"
require "./property/padding"
require "./property/box_shadow"

module Style

  alias Length = Em | Int32 | Px | Percent

  module Class_Methods
    def render
      style = self.new
      style.render
    end
  end

  macro included
    extend Style::Class_Methods
  end

  macro p(name, *args)
    {{name.gsub(/-/, "_").id}}({{ *args }})
  end

  struct Writer_Property

    def initialize(@io : IO::Memory, @key : String)
      @io << " " << @key << ":"
      yield self
      @io << ";\n"
    end # === def initialize

    def raw
      yield(@io)
    end # === def raw

    def <<(*values)
      values.each { |x|
        case x
        when Char
          @io << " " << x
        else
          @io << " " << x.to_css
        end
      }
    end

  end # === struct Writer_Property

  module Class_Methods

    def join(*args)
      args.map { |x|
        case x
        when Char
          x
        else
          x.to_css
        end
      }.join(", ")
    end # === def join

    def write_property(io : IO::Memory, key : String)
     Writer_Property.new(io, key) { |x|
        yield x
      }
    end

  end # === module Class_Methods

  extend Class_Methods

  @in_nest = false

  def initialize
    @content = IO::Memory.new
  end # === def initialize

  def to_css
    @content.to_s
  end

  def render
    with self yield(self)
  end # === def render

  def s(name : String)
    @content << "\n" << name << " {"
    with self yield
    @content << " }"

    return self
  end

  def s_alias(name : String)
    raise Exception.new("Nesting of :rename not allowed.") if @in_nest
    @in_nest = true
    with self yield(name)
    @in_nest = false
    return self
  end

  def css
    @content.to_s
  end

end # === module Style
