# frozen_string_literal: true
require "psych"

# namespace for all individual package validators
module HathiTrust::SIP
  class YAML
    def self.load(*args)
      ast = Psych.parse(*args)
      return false unless ast

      class_loader = Psych::ClassLoader.new
      Psych::Visitors::ToRuby.new(NoTimeScanner.new(class_loader),
        class_loader).accept(ast)
    end
  end

  class NoTimeScanner < Psych::ScalarScanner
    # Don't try to actually parse the time.
    def parse_time(string)
      string
    end
  end
end
