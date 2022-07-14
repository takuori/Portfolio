# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create(
  email: "admin@com",
  password: "photrain"
)

Tag.create([
  { name: '中央線' },
  { name: '総武線' },
  { name: '山手線' },
  { name: '京浜東北線' },
  { name: '東海道線' },
  { name: '横須賀線' },
  { name: '横浜線' },
  { name: '根岸線' },
  { name: '常磐線' },
  { name: '相模線' }
  ])