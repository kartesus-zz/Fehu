module Fehu
module Std

  class Tag
    def initialize(name, values)
      @name = name
      @values = values
    end

    def call(i)
      return @name if i == 0
      @values[i - 1]
    end
  end

end
end
