class RenamePriceYenToPrice < ActiveRecord::Migration[5.1]
  def change
    rename_column :cart_items, :price_yen, :price
  end
end
