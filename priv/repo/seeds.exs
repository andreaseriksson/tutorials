# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tutorial.Repo.insert!(%Tutorial.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Tutorial.Products

Enum.each(1..100, fn _ ->
  Products.create_product(%{
    name: Faker.Beer.En.name,
    description: "#{Faker.Beer.En.style} - #{Faker.Beer.En.brand}",
    price: (Faker.random_between(200, 1000) / 100.0)
  })
end)
