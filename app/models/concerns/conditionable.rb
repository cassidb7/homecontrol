module Conditionable
  extend ActiveSupport::Concern

  def false?(condition)
    condition.to_s == "true"
  end
end
