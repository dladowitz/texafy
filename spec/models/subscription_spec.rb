require 'rails_helper'

describe Subscription do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :level }

  it "has a valid factory" do
    subscription = create :subscription
    expect(subscription).to be_instance_of Subscription
  end
end
