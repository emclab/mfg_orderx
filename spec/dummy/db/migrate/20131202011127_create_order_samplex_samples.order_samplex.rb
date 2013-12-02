# This migration comes from order_samplex (originally 20131108213522)
class CreateOrderSamplexSamples < ActiveRecord::Migration
  def change
    create_table :order_samplex_samples do |t|
      t.integer :order_id
      t.integer :last_updated_by_id
      t.integer :qty
      t.date :delivery_date
      t.text :sample_requirement
      t.text :quality_feedback
      t.boolean :oked, :default => false
      t.date :oked_date
      t.string :shipping_tracking
      t.text :shipping_instruction
      t.date :shipping_date

      t.timestamps
    end
    
    add_index :order_samplex_samples, :order_id
  end
end
