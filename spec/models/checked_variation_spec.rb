require 'rails_helper'

describe CheckedVariation do
  it { should validate_presence_of :letters }
  it { should validate_presence_of :position }
  it { should validate_presence_of :entries }

  it "has a valid factory" do
    checked_variation = create :checked_variation
    expect(checked_variation).to be_instance_of CheckedVariation
  end

  it "creates a checked_variation when it doesn't exists" do
    CheckedVariation.create_or_update(letters: "aaa", position: 1, entries: 20)
    expect(CheckedVariation.find_by_letters("aaa").entries).to eq 20
  end

  it "updates a checked_variation when it already exists" do
    checked_variation = create :checked_variation, {letters: "aaa", position: 2, entries: 20}
    CheckedVariation.create_or_update(letters: "aaa", entries: 30)
    expect(CheckedVariation.find_by_letters("aaa").entries).to eq 30
  end
end
