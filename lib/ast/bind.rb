class Fehu::AST::Bind
  def inspect
    "#{@atom.inspect} = #{@expr.inspect}" 
  end

  def run(env)
    env[@atom.run(env)] = @expr.run(env)
  end
end
