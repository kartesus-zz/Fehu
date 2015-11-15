module Fehu
module Std

  class Case
    def initialize(env, params, expr)
      @env = env
      @expr = expr
      @params = params
    end

    def call(args)
      return unless args.size == @params.size
      params = @params.zip(args).to_h
      env = @env.merge(params)
      @expr.run(env) 
    end
  end

end
end
