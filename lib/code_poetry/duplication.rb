module CodePoetry
  class Duplication
    attr_reader :mass, :methods, :node, :severity

    def initialize(severity, node, mass, methods)
      @severity = severity
      @node     = node
      @mass     = mass
      @methods  = methods
    end
  end
end
