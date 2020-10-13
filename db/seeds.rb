# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create(name: 'acura', url: 'https://cars.av.by/acura')
Category.create(name: 'Alfa Romeo', url: 'https://cars.av.by/alfa-romeo')
Category.create(name: 'Audi', url: 'https://cars.av.by/audi')

c = Category.take
c.products.create([
                    { ad_id: 111, name: 'ILX', url: 'https://cars.av.by/acura/ilx', city: 'Minsk', price: 11 },
                    { ad_id: 222, name: 'Legend', url: 'https://cars.av.by/acura/legend', city: 'Brest', price: 22 },
                    { ad_id: 333, name: 'MDX', url: 'https://cars.av.by/acura/mdx', text: 'теееекссттт', price: 33 }
                  ])
