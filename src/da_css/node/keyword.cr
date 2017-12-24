
module DA_CSS

  module Node

    struct Keyword

      @raw : Position_Deque
      @name : String
      def initialize(@raw)
        @name = @raw.to_s
        {% begin %}
          case @name
          when {{ system("cat #{__DIR__}/../keywords.txt").split.map(&.strip).reject(&.empty?).map(&.stringify).join(", ").id }}
            :ok
          end
        {% end %}
      end # === def initialize

      def to_s
        @name
      end # === def to_s

      def print(printer : Printer)
        printer.raw! @name
      end # === def print

    end # === struct Keyword

  end # === module Node

end # === module DA_CSS
