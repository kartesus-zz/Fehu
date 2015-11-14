class Fehu::AST::Call
  def inspect
    "#{@callable.inspect}(#{@arguments.map(&:inspect).join(", ")})"
  end
end
