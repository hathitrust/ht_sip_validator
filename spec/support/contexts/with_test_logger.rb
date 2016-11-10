# frozen_string_literal: true
require "spec_helper"

shared_context "with test logger" do
  # Stand in class for the Logger
  class TestLogger
    attr_accessor :logs, :level
    def info(message)
      self.logs ||= []
      self.logs << message
    end

    def error(message)
      info(message)
    end
  end
end
