require 'rails_helper'

describe Academic do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :role }
  it { should validate_presence_of :uta_id }

  it { should validate_uniqueness_of :uta_id }
  it { should validate_uniqueness_of :email }

  it "has a valid factory" do
    academic = create :academic
    expect(academic).to be_instance_of Academic
  end
end
