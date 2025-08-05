require 'faker'

# Step 1: Create a hash with different fake data
fake_data = {
  text: Faker::Lorem.word, 
  number: Faker::Number.number(digits: 5),
  phone_number: Faker::PhoneNumber.phone_number,
  url: Faker::Internet.url,
  name: Faker::Name.name,
  email: Faker::Internet.email,
  address: Faker::Address.full_address,
  company: Faker::Company.name,
  job_title: Faker::Job.title,
  uuid: Faker::Internet.uuid
fake_date = Faker::Date.backward(days: 14)  # Random date from last 14 days
fake_time = Faker::Time.backward(days: 14, period: :evening)  # Random time from evening in last 14 days
}
puts JSON.generate(fake_data)

