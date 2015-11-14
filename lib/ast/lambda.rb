require_relative '../std/lambda'

class Fehu::AST::Lambda
  def inspect
    "[ #{@params.map(&:inspect).join(', ')} -> #{@expr.inspect} ]"
  end
  
  def run(env)
    Fehu::Std::Lambda.new(env, @params.map{|node| node.run(env) }, @expr)
  end
end
