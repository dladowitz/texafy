class SubscriptionsController < ApplicationController
  before_action :set_user

  def new
    @subscription = @user.build_subscription
  end

  def create
    @subscription = @user.build_subscription subscription_params

    begin
      raise "Please, check subscription errors" unless @subscription.valid?

      # Maybe change the plan name on stripe
      stripe_customer = Stripe::Customer.create( source: params["stripeToken"], plan: subscription_params[:level], email: params["stripeEmail"] )
      @user.update_attributes(stripe_id: stripe_customer.id)
      SubscriptionMailer.new_subscription_alert_email(@user, @subscription).deliver
      @subscription.save

      redirect_to @user, notice: 'Registration was successfully created.'
    rescue => e
      flash[:error] = e.message
      render :new
    end
  end

  def edit
    @subscription = @user.subscription
  end

  def destroy
    @subscription = @user.subscription

    customer = Stripe::Customer.retrieve(@user.stripe_id)
    stripe_subscription_id = customer.subscriptions.first.id
    customer.subscriptions.retrieve(stripe_subscription_id).delete(:at_period_end => true)

    @subscription.update_attributes(level: 0)
    redirect_to @user
  end

  private
  def set_user
    @user = User.find params[:user_id]
  end

  def subscription_params
    params.require(:subscription).permit(:level)
  end
end
