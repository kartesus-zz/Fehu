require_relative '../std/case'

class Fehu::AST::Case
  def run(env)
    Fehu::Std::Case.new(env, @params.map{|node| node.run(env) }, @expr)
  end
end
