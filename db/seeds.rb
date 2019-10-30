User.create!(name: "Sample_Name",
             email: "sample@sample.com",
             password: "password",
             password_confirmation: "password",
             admin: true)

100.times do |n|
  name = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  employee_number = n+1
  user_card_id = n+1
  User.create!(name: name,
              email: email,
              employee_number: employee_number,
              user_card_id: user_card_id,
              password: password,
              password_confirmation: password)
end