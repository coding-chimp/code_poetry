module CodePoetry
  class Method
    attr_accessor :node, :name, :first_line, :last_line, :complexity

    def initialize(node, name, first_line, last_line)
      @node       = node
      @name       = name
      @first_line = first_line
      @last_line  = last_line
      @complexity = 0
    end

    def smelly?
      complexity > 25
    end

    def pretty_name
      symbol = node == :def ? "." : "#"
      name.prepend(symbol)
    end

  end
end
