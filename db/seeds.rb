User.create!(name: "SampleUser",
             email: "sample@email.com",
             employee_number: 1,
             user_card_id: 1,
             password: "password",
             password_confirmation: "password",
             department: "管理者",
             admin: true)
             
User.create!(name: "上長A",
             email: "superior-a@email.com",
             employee_number: 2,
             user_card_id: 2,
             password: "password",
             password_confirmation: "password",
             department: "上長A",
             superior: true)
             
User.create!(name: "上長B",
             email: "superior-b@email.com",
             employee_number: 3,
             user_card_id: 3,
             password: "password",
             password_confirmation: "password",
             department: "上長B",
             superior: true)

100.times do |n|
  name = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  employee_number = n+4
  user_card_id = n+4
  User.create!(name: name,
              email: email,
              employee_number: employee_number,
              user_card_id: user_card_id,
              password: password,
              password_confirmation: password,
              admin:     false,
              superior:  false)
end