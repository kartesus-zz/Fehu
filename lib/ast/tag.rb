require_relative '../std/tag'

class Fehu::AST::Tag
  def inspect
    "{:#{@name} #{@values.map(&:inspect).join(' ')}}"
  end
  
  def run(env)
    Fehu::Std::Tag.new(@name.to_sym, @values.map{|node| node.run(env) }
)
  end
end
