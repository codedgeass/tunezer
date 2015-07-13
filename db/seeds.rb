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
multiple   = Genre.create name: 'Multiple'
other      = Genre.create name: 'Other'

grant_park    = Venue.create name: 'Grant Park'
chicago       = City.create name: 'Chicago'
illinois      = State.create name: 'Illinois'
united_states = Country.create name: 'United States'

soldier_field = Venue.create name: 'Soldier Field'

Concert.create(name: 'Lollapalooza', number_of_votes: 0, street_address: '337 E Randolph St', 
  zip: '60601', genre_id: multiple.id, venue_id: grant_park.id, city_id: chicago.id, state_id: illinois.id,
  country_id: united_states.id, user_id: seed_user.id)
  
Concert.create(name: 'Spring Awakening', number_of_votes: 0, street_address: '1410 Museum Campus Dr', 
  zip: '60605', genre_id: electronic.id, venue_id: soldier_field.id, city_id: chicago.id, state_id: illinois.id,
  country_id: united_states.id, user_id: seed_user.id)
