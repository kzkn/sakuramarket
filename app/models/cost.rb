module Cost
  def self.of_cod(amount)
    return 300 if amount < 10000
    return 400 if amount < 30000
    return 600 if amount < 100000
    return 1000
  end

  def self.of_ship(quantity)
    return 0 unless quantity > 0
    # 1..5  -> 600
    # 6..10 -> 1200
    600 * (((quantity - 1) / 5) + 1)
  end
end
