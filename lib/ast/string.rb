class Fehu::AST::String
  def inspect
    "'#{@value}'"
  end

  def run(_env)
    @value.to_s
  end
end
