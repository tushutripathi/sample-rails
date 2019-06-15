# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require("faker")

# For deterministic random
Faker::Config.random = Random.new(42)

# Insert if title already doesn't exist else update
def upsert(model, params)
  prev = model.find_by(title: params[:title])
  prev.present? ? prev.update!(params) : model.create!(params)
  model.find_by(title: params[:title])
end

10.times do
  upsert(Blog, {title: Faker::Games::Pokemon.unique.name,
  content: Faker::ChuckNorris.fact})
end
