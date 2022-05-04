# frozen_string_literal: true

require "spec_helper"

class TestLogger
  attr_accessor :logs, :level
  def info(message)
    self.logs ||= []
    self.logs << message
  end

  def error(message)
    info(message)
  end

  def warn(message)
    info(message)
  end

  def formatter=(_)
  end
end
