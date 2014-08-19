module ApplicationHelper
  def has_error_class(errors, symbol)
    (errors.any? && errors.keys.any?{ |x| x == symbol }) ? "has-error" : ""
  end
end
