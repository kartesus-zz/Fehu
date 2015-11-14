class Fehu::AST::Tag
  def inspect
    "{:#{@name} #{@values.map(&:inspect).join(' ')}}"
  end
end
