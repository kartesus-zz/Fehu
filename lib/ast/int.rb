class Fehu::AST::Int
  def inspect
    @value.to_s
  end

  def run(_env)
    @value.to_i
  end
end
