class Fehu::AST::Call
  def rewrite
    super
    blanks = @arguments.select{|a| a.class.name =~ /Blank/ }
      .map{|b| Fehu::AST::Atom.new(b.value.to_sym) }
    return self if blanks.empty?
    @arguments = @arguments.map{|a| a.is_a?(Fehu::AST::Blank) ? Fehu::AST::Atom.new(a.value) : a }
    Fehu::AST::Lambda.new([Fehu::AST::Case.new(blanks, self)])
  end

  def run(env)
    callable = @callable.run(env)
    if env.key?(callable)
      fn = env[callable]
      fn.call(arguments(@arguments, env))
    elsif callable.is_a?(Fehu::Std::Lambda)
      callable.call(arguments(@arguments, env))
    elsif Kernel.respond_to?(callable)
      Kernel.send(callable, *arguments(@arguments, env))
    else
      object = @arguments.first.run(env)
      object = env[object] if object.is_a?(Symbol) && env.key?(object)
      method = @callable.run(env)
      object.send(method, *arguments(@arguments.slice(1..-1), env))
    end
  end

  def arguments(args, env)
    args.map do |arg|
      if arg.class.name =~ /Atom/
        env.fetch(arg.run(env))
      else
        arg.run(env)
      end
    end
  end
end
