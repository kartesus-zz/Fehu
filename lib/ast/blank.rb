require 'securerandom'

class Fehu::AST::Blank
  attr_reader :value

  def initialize
    @value = SecureRandom.hex(4)
  end
end
