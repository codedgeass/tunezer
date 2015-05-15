seed_user = User.new username: 'admin', password: 'admin00', email: 'admin@tunezer.com', admin: true
seed_user.skip_confirmation!
seed_user.save!

blues      = Genre.create name: 'Blues'
country    = Genre.create name: 'Country'
classical  = Genre.create name: 'Classical'
electronic = Genre.create name: 'Electronic'
ethnic     = Genre.create name: 'Ethnic'
hip_hop    = Genre.create name: 'Hip Hop'
jazz       = Genre.create name: 'Jazz'
pop        = Genre.create name: 'Pop'
rnb        = Genre.create name: 'R&B'
rock       = Genre.create name: 'Rock'
other      = Genre.create name: 'Other'

bayfront_park = Venue.create name: 'Bayfront Park'
miami         = City.create name: 'Miami'
florida       = State.create name: 'Florida'
united_states = Country.create name: 'United States'

Concert.create(name: 'Ultra Music Festival', number_of_votes: 0, street_address: '301 Biscayne Blvd', 
  zip: '33132', genre_id: electronic.id, venue_id: bayfront_park.id, city_id: miami.id, state_id: florida.id,
  country_id: united_states.id, user_id: seed_user.id)