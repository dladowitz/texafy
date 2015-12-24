# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  level      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_user_id  (user_id)
#

class Subscription < ActiveRecord::Base
  belongs_to :user

  def level_in_words
    case self.level
    when 0
      "None"
    when 101
      "Two Guys In A Garage"
    when 102
      "Seed Money"
    when 103
      "Venture Capital"
    when 104
      "IPO"
    else
      self.level
    end
  end

  def price
    case self.level
    when 0
      0
    when 101
      5.50
    when 102
      11.00
    when 103
      25.00
    when 104
      50.00
    else
      self.level
    end
  end
end
