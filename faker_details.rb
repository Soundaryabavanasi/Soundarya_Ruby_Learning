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
}
## Working as expected when i am pushing the code the changes is pushing into the main branch
# Step 2: Genarate the values in json format
puts JSON.generate(fake_data)

