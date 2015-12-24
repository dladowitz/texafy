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
      @subscription.save
      redirect_to @user, notice: 'Registration was successfully created.'
    rescue => e
      flash[:error] = e.message
      render :new
    end
  end

  def edit
  end

  def destroy
  end

  private
  def set_user
    @user = User.find params[:user_id]
  end

  def subscription_params
    params.require(:subscription).permit(:level)
  end
end
