class Fehu::AST::Lambda
  def inspect
    "| #{params.map(&:inspect).join(', ')} -> #{expr.inspect} |"
  end
end
