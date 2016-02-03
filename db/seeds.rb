# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
r1 = Role.create({name: "Regular", description: "Can read items"})
r2 = Role.create({name: "Blogger", description: "Can create posts and edit/delete their own posts"})
r3 = Role.create({name: "Admin", description: "Can do anything they want"})
u1 = User.create({email: "galen.w.burghardt@gmail.com", role_id: 3})