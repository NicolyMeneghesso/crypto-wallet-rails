class CreateCoins < ActiveRecord::Migration[7.0]
  def change
    create_table :coins do |t|
      t.string :description
      t.string :acronym
      t.string :url_image

      t.timestamps
    end

    add_reference :coins, :mining_type, foreign_key: true
  end
end
