class CreateValues < ActiveRecord::Migration[6.0]
  def change
    create_table :values do |t|
      t.integer :input
      t.string :output

      t.timestamps
    end
  end
end
