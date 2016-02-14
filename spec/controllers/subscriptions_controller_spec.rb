require 'rails_helper'

RSpec.describe SubscriptionsController, :type => :controller do
  before(:each) do
    @user = create :user
  end

  describe "GET new" do
    it "returns http success" do
      get :new, user_id: @user.id
      expect(response).to be_success
    end
  end

  describe "POST create" do
    subject { get :create, user_id: @user.id, stripeToken: "fake-token", stripeEmail: "some@email.com", subscription: { level: 1 } }

    it "creates a new subscription in the database" do
      allow(Stripe::Customer).to receive(:create).and_return( OpenStruct.new({id: "10"}) )
      expect{ subject }.to change { Subscription.count }.by 1
    end

    it "updates the user record with a stripe_id" do
      allow(Stripe::Customer).to receive(:create).and_return( OpenStruct.new({id: "10"}) )
      subject
      expect(assigns(:user).stripe_id).to eq "10"
    end

  end

  describe "GET edit" do
    it "returns http success" do
      get :edit, user_id: @user.id
      expect(response).to be_success
    end
  end
end
