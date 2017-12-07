
module DA_CSS

  struct Chars

    include Enumerable(Char)

    SPACE    = ' '
    NEW_LINE = '\n'

    @raw    : Deque(Char)
    getter parent : Parser
    getter pos = 0
    getter pos_line = 1

    def initialize(parent : Parser)
      @parent   = parent
      @raw      = Deque(Char).new
      @frozen   = false
      @pos      = parent.pos
      @pos_line = parent.pos_line
    end # === def initialize

    def join(*args)
      @raw.join(*args)
    end

    def each
      prev = nil
      @raw.each { |c|
        next if prev && prev.whitespace? && c.whitespace?
        yield c
        prev = c
      }
    end # === def each

    def to_s
      io = IO::Memory.new
      last_i = @raw.size - 1
      @raw.each_with_index { |c, index|
        io << c unless last_i == index && c.whitespace?
      }
      return io.to_s
    end # === def to_s

    def inspect(io)
      io << "Chars["
      @raw.each_with_index { |c, index|
        io << ", " unless index == 0
        io << c.inspect
      }
      io << "]"
    end # === def inspect

    def raise_if_frozen!
      raise Exception.new("Chars (#{to_s.inspect}) is frozen.") if @frozen
      false
    end

    def push(c : Char)
      raise_if_frozen!
      if !empty? && last.whitespace? && c.whitespace?
        return self
      end

      if empty? && c.whitespace?
        return self
      end

      @raw.push valid!(c)
    end # === def push

    def last
      @raw.last
    end # === def last

    def size
      @raw.size
    end # === def size

    def empty?
      size == 0
    end # === def empty?

    def prev(i : Int32 = 1)
      @raw[@raw.size - 1 - i]
    end # === def prev(i : Int32 = 1)

    def [](i : Int32)
      valid!(@raw[i])
    end

    def valid!(c : Char)
      case c
      when 'A'..'Z', 'a'..'z', '0'..'9',
        ' ', '\n',
        '(', ')', '{', '}', '\'', '"',
        '=', ';', '/', '*', '?', '#', '.', ':', '-'
        c
      else
        raise Error.new("Invalid character: #{c.inspect} (in #{self.join.inspect})", self)
      end
    end # === def valid_codepoint?

    def pop
      raise_if_frozen!
      @raw.pop
    end # === def pop

    def all?(r : Range)
      @raw.all? { |c|
        r.includes?(c.ord)
      }
    end # === def all?

    def freeze!
      return self if @frozen
      @frozen = true
      return self
    end

    def pos_summary_in_english
      "Line: #{@pos_line + 1} Column: #{@pos + 1}"
    end # === def pos_summary_in_english

    def print(printer : Printer)
      each { |c| printer.raw! c }
    end # === def print

    module Common

      def whitespace?(c : Char)
        c.whitespace?
      end # === def whitespace?

      def whitespace?(i : Int32)
        i.chr.whitespace?
      end # === def whitespace?

    end # === module Common

    extend Common
    include Common

  end # === class Chars

end # === module DA_CSS

