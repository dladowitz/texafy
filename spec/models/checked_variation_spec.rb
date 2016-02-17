require 'rails_helper'

describe CheckedVariation do
  it { should validate_presence_of :letters }
  it { should validate_presence_of :position }

  it "has a valid factory" do
    checked_variation = create :checked_variation
    expect(checked_variation).to be_instance_of CheckedVariation
  end
end
