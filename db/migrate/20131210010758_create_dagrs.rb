class CreateDagrs < ActiveRecord::Migration
  def change
    create_table :dagrs do |t|

      t.timestamps
    end
  end
end
