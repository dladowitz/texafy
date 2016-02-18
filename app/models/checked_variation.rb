# == Schema Information
#
# Table name: checked_variations
#
#  id         :integer          not null, primary key
#  letters    :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  entries    :integer
#

class CheckedVariation < ActiveRecord::Base
  validates :letters, :position, :entries, presence: true
  validates :letters, uniqueness: true

  def self.create_or_update(options)
    checked_variation = CheckedVariation.find_or_create_by(letters: options[:letters])
    checked_variation.update(options)
  end
end
