# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(email: 'admin@example.com', password: 'admin@example.com', password_confirmation: 'admin@example.com')
50.times do
    Course.create!([{
      title: Faker::Educator.course_name,
      description: Faker::TvShows::BojackHorseman.quote,
      user_id: User.first.id
      short_description: Faker::TvShows::BojackHorseman.tongue_twister,
      language: Faker::ProgrammingLanguage.name,
      level: 'Beginner',
      price: Faker::Number.between(from:1000, to: 2000)
    }])
  end