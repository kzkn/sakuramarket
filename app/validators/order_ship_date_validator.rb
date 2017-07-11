class OrderShipDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    candidates = Order.ship_date_candidates
    unless candidates.include?(value)
      record.errors[attribute] << (options[:message] || "is not included in the list")
    end
  end
end
