# typed: false
# frozen_string_literal: true

require 'sorbet-runtime'

class Test
  extend T::Sig
  sig {params(a: String).returns(String)}
  def cool(a)
    return 10
  end
end

a = Test.new
a.cool(1)

