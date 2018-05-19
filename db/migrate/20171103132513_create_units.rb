class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string        :name
      t.string        :abbreviation
      t.string        :kind
      t.decimal       :conversion_rate, precision: 10, scale: 2
      t.boolean       :default_unit
      t.timestamps
    end
  end
end
