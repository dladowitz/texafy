# == Schema Information
#
# Table name: academics
#
#  id             :integer          not null, primary key
#  uta_id         :string
#  first_name     :string
#  last_name      :string
#  email          :string
#  employee_title :string
#  role           :string
#  student_level  :string
#  college        :string
#  major          :string
#  phone          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Academic < ActiveRecord::Base
  validates :uta_id, presence: true
  validates :email, :uta_id, uniqueness: true
end
