module Fehu
module Std

  class Case
    def initialize(env, params, expr)
      @env = env
      @expr = expr
      @params = params
    end

    def call(args)
      return :no_match unless args.size == @params.size
      return :no_match unless @params.match?(args)

      matches = matched @params.zip(args)
      env = @env.merge(matches.to_h)
      env.delete :_
      @expr.run(env) 
    end

    def matched(params)
      params.reduce([]){|m, (arg, value)| m.concat(arg.matches value) }
    end
  end

end
end
