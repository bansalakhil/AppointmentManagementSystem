# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

 SiteLayout.create!
 Admin.create!({name: 'vinsol', email: 'newnewvinsol@vinsol.com', password: 'vinsolvinsol', phone_number: '2345678901456', confirmed_at: Time.now})
