module CodePoetry
  class Method
    attr_accessor :name, :first_line, :last_line, :complexity

    def initialize(name, first_line, last_line)
      @name       = name
      @first_line = first_line
      @last_line  = last_line
      @complexity = 0
    end

    def smelly?
      complexity > 25
    end

  end
end
