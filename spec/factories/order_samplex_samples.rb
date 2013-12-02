# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order_samplex_sample, :class => 'OrderSamplex::Sample' do
    order_id 1
    last_updated_by_id 1
    qty 1
    delivery_date "2013-11-08"
    sample_requirement "MyText"
    quality_feedback "MyText"
    oked false
    oked_date "2013-11-08"
    shipping_tracking "MyString"
    shipping_instruction "MyText"
    shipping_date "2013-11-08"
  end
end
