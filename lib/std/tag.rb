module Fehu
module Std

  class Tag
    attr_reader :name, :values

    def initialize(name, values)
      @name = name
      @values = values
    end

    def call(i)
      return @name if i == 0
      @values[i - 1]
    end

    def match?(tag)
      @name == tag.name &&
      @values.match?(tag.values)
    end

    def matches(tag)
      @values.zip(tag.values)
    end
  end

end
end
