class Fixnum
  alias :add :+
  alias :mult :*
  alias :subtr :-
  alias :div :/

  def match?(n)
    self == n
  end

  def matches(_)
    [[:_, self]]
  end
end

class Float
  alias :add :+
  alias :mult :*
  alias :subtr :-
  alias :div :/

  def match?(n)
    self == n
  end

  def matches(_)
    [[:_, self]]
  end
end

class String
  def str(*args)
    self + args.join
  end

  def match?(s)
    self == s
  end

  def matches(_)
    [[:_, self]]
  end
end

class Array
  def match?(a)
    zip(a).map{|v1, v2| v1.match?(v2) }.all?
  end
end

class Symbol
  def match?(s)
    true
  end

  def matches(v)
    [[self, v]]
  end
end
