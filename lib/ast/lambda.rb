require_relative '../std/lambda'

class Fehu::AST::Lambda
  def run(env)
    Fehu::Std::Lambda.new(env, @cases)
  end
end
