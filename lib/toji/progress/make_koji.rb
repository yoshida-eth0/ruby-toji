require 'toji/progress/make_koji/base'
require 'toji/progress/make_koji/expected'

module Toji
  module Progress
    module MakeKoji
      def self.expected(jobs=Expected::TEMPLATES[:default])
        Expected.new(jobs)
      end
    end
  end
end
