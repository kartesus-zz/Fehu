class Fehu::AST::Atom
  def inspect
    "#{@name}"
  end

  def run(env)
    env[@name.to_sym] || @name.to_sym
  end
end
