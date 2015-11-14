class Fixnum
  alias :add :+
  alias :mult :*
  alias :substr :-
  alias :div :/
end

class Float
  alias :add :+
  alias :mult :*
  alias :substr :-
  alias :div :/
end

class String
  def str(*args)
    self + args.join
  end
end
