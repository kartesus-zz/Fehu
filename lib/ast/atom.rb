class Fehu::AST::Atom
  def inspect
    "#{@name}"
  end

  def run(_env)
    @name.to_sym
  end
end
