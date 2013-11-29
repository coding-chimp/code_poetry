module CodePoetry
  class Smell
    attr_accessor :type, :method

    def initialize(type, method = nil)
      @type   = type
      @method = method
    end

    def complex_class?
      @type == "ComplexClass"
    end

    def complex_class_definition?
      @type == "ComplexClassDefinition"
    end

    def complex_method?
      @type == "ComplexMethod"
    end
  end
end
