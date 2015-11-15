require 'pp'

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
      return unless matched(params)

      env = @env.merge(params)
      @expr.run(env) 
    end

    def matched(params)
      params.map do |arg, value|
        case arg
        when Fixnum then arg == value
        when Symbol then true
        end
      end.all?
    end
  end

end
end
