module CodePoetry
  class Smell
    attr_reader :object, :type

    def initialize(type, object = nil)
      @type     = type
      @object   = object
    end
  end
end
