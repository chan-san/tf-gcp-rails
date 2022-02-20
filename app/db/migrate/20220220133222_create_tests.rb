class CreateTests < ActiveRecord::Migration[6.1]
  def up
    create_table :tests do |t|
      t.integer :value

      t.timestamps
    end

    10.times do
      Test.create(value: rand * 100)
    end
  end

  def down
    drop_table :tests
  end
end
