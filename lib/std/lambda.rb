module Fehu
module Std

  class Lambda
    def initialize(env, cases)
      @cases = cases
      @env   = env
    end

    def call(args)
      @cases.map{|c| c.run(@env).call(args) }.compact.first
    end
  end

end
end
