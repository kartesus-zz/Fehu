module Fehu
module Std

  class Lambda
    def initialize(env, cases)
      @cases = cases
      @env   = env
    end

    def call(args)
      for c in @cases
        result = c.run(@env).call(args)
        return result unless result == :no_match
      end
      raise "No match"
    end
  end

end
end
