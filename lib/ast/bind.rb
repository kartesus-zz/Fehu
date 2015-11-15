class Fehu::AST::Bind
  def run(env)
    env[@atom.run(env)] = @expr.run(env)
  end
end
