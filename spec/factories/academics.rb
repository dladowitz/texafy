# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :academic do
    uta_id "dml123456"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    employee_title "Professor of Monkey Business"
    role "faculty"
    student_level nil
    college "College of Zoology"
    major nil
    phone "408 867 5309"
  end
end
