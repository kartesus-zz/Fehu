class Fehu::AST::Float
  def inspect
    @value.to_s
  end

  def run(_env)
    @value.to_f
  end
end
