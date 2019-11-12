# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Craft.create(name: 'Knitting', id: 1)
Craft.create(name: 'Crocheting', id: 2)
Craft.create(name: 'Weaving', id: 3)
Craft.create(name: 'Spinning', id: 4)

Yarn.create(name: '220', company_name: 'Cascade Yarns', weight_name: 'Worsted')
