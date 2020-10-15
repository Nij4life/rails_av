# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create(name: 'Acura', url: 'https://cars.av.by/acura')
Category.create(name: 'Alfa Romeo', url: 'https://cars.av.by/alfa-romeo')
Category.create(name: 'Audi', url: 'https://cars.av.by/audi')

c = Category.take
c.products.create([
                    { ad_id: 111, name: 'ILX', url: 'https://cars.av.by/acura/ilx', city: 'Minsk', photo_url: 'https://cars.av.by/acura/zdx/18197444', price: 11 },
                    { ad_id: 222, name: 'Legend', url: 'https://cars.av.by/acura/legend', city: 'Brest', photo_url: 'https://cars.av.by/acura/tsx/100030897', price: 22 },
                    { ad_id: 333, name: 'MDX', url: 'https://cars.av.by/acura/mdx', description: 'теееекссттт', photo_url: 'https://cars.av.by/acura/ilx/19939087', price: 33 }
                  ])
Category.find(2).products.create(ad_id: 444, name: 'GTV', url: 'https://cars.av.by/alfa-romeo/gtv', city: 'Minsk', photo_url: 'https://cars.av.by/alfa-romeo/gtv/18718527', price: 12_323)
Category.find(3).products.create(ad_id: 555, name: 'A7', url: 'https://cars.av.by/audi/a7', city: 'Minsk', photo_url: 'https://cars.av.by/audi/a7/100014299', price: 777_777)
Category.find(3).products.create(ad_id: 666, name: 'A4', url: 'https://cars.av.by/audi/a4', city: 'Grodno', photo_url: 'https://cars.av.by/audi/a4/100027683', price: 6_777)
