module CodePoetry
  class Method
    attr_reader :first_line, :last_line, :name
    attr_accessor :complexity, :duplication_count, :node

    def initialize(node, name, first_line, last_line, location)
      @node              = node
      @name              = name
      @first_line        = first_line
      @last_line         = last_line
      @complexity        = 0
      @duplication_count = 0

      @location = location
    end

    def smelly?
      @complexity > 25
    end

    def duplicated?
      @duplication_count > 0
    end

    def pretty_name
      symbol = @node == :def ? "." : "#"
      "#{symbol}#{@name}"
    end

    def pretty_location
      "#{@location}:#{@first_line}..#{@last_line}"
    end

    def increase_duplication_count
      @duplication_count =+ 1
    end

  end
end
