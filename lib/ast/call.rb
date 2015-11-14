class Fehu::AST::Call

  def run(env)
    callable = @callable.run(env)
    if env.key?(callable)
      fn = env[callable]
      fn.call(*arguments(@arguments, env))
    elsif callable.is_a?(Fehu::Std::Lambda)
      callable.call(*arguments(@arguments, env))
    elsif Kernel.respond_to?(callable)
      Kernel.send(callable, *arguments(@arguments, env))
    else
      object = @arguments.first.run(env)
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
