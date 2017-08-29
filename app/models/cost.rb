module Cost
  def self.of_cod(amount)
    if amount < 10000
      300
    elsif amount < 30000
      400
    elsif amount < 100000
      600
    else
      1000
    end
  end

  def self.of_ship(quantity)
    return 0 if quantity <= 0
    # 1..5  -> 600
    # 6..10 -> 1200
    600 * (((quantity - 1) / 5) + 1)
  end
end
