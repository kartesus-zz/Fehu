class Fehu::AST::Node
  def rewrite
    instance_variables.each do |v|
      x = instance_variable_get(v)
      x = x.map(&:rewrite) if x.is_a?(Array)
      x = x.rewrite if x.respond_to?(:rewrite)
      instance_variable_set(v, x)
    end
    self
  end
end
