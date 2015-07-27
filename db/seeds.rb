# Users

seed_user = User.new username: 'admin', password: 'admin00', email: 'admin@tunezer.com', admin: true
seed_user.skip_confirmation!
seed_user.save!

seed_user = User.new username: 'World', password: 'world00', email: 'world@tunezer.com'
seed_user.skip_confirmation!
seed_user.save!


# Genres

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


# Venues

grant_park         = Venue.create name: 'Grant Park'
soldier_field      = Venue.create name: 'Soldier Field'
montrose_beach     = Venue.create name: 'Montrose Beach'
union_park         = Venue.create name: 'Union Park'
toyota_park        = Venue.create name: 'Toyota Park'
millennium_park    = Venue.create name: 'Millennium Park'
northerly_island   = Venue.create name: 'Northerly Island'
addams_medill_park = Venue.create name: 'Addams Medill Park'
douglas_park       = Venue.create name: 'Douglas Park'


# Cities

chicago    = City.create name: 'Chicago'
bridgeview = City.create name: 'Bridgeview'


# States

illinois      = State.create name: 'Illinois'


# Countries

united_states = Country.create name: 'United States'


# Concerts

lollapalooza = Concert.create(name: 'Lollapalooza', votes: 0, street_address: '337 E Randolph St', 
  zip: '60601', genre_id: multiple.id, venue_id: grant_park.id, city_id: chicago.id, state_id: illinois.id,
  country_id: united_states.id, user_id: seed_user.id)

spring_awakening = Concert.create(name: 'Spring Awakening', votes: 0, 
  street_address: '1410 Museum Campus Dr', zip: '60605', genre_id: electronic.id, venue_id: soldier_field.id, 
  city_id: chicago.id, state_id: illinois.id, country_id: united_states.id, user_id: seed_user.id)

wavefront = Concert.create(name: 'Wavefront', votes: 0, street_address: '4400 North Lake Shore Drive', 
  zip: '60640', genre_id: electronic.id, venue_id: montrose_beach.id, city_id: chicago.id, state_id: illinois.id,
  country_id: united_states.id, user_id: seed_user.id)

north_coast = Concert.create(name: 'North Coast', votes: 0, street_address: '1501 W Randolph St', 
  zip: '60607', genre_id: electronic.id, venue_id: union_park.id, city_id: chicago.id, state_id: illinois.id,
  country_id: united_states.id, user_id: seed_user.id)

b96_summer_bash = Concert.create(name: 'B96 Summer Bash', votes: 0, 
  street_address: '7000 Harlem Ave, Bridgeview', zip: '60455', genre_id: pop.id, venue_id: toyota_park.id, 
  city_id: bridgeview.id, state_id: illinois.id, country_id: united_states.id, user_id: seed_user.id)

chicago_blues_festival = Concert.create(name: 'Chicago Blues Festival', votes: 0, 
  street_address: '337 E Randolph St', zip: '60601', genre_id: blues.id, venue_id: grant_park.id, 
  city_id: chicago.id, state_id: illinois.id, country_id: united_states.id, user_id: seed_user.id)

chicago_jazz_festival = Concert.create(name: 'Chicago Jazz Festival', votes: 0, 
  street_address: '201 E Randolph St', zip: '60602', genre_id: jazz.id, venue_id: millennium_park.id, 
  city_id: chicago.id, state_id: illinois.id, country_id: united_states.id, user_id: seed_user.id)

lakeshake = Concert.create(name: 'LakeShake', votes: 0, street_address: '1300 S Linn White Dr', 
  zip: '60605', genre_id: country.id, venue_id: northerly_island.id, city_id: chicago.id, state_id: illinois.id,
  country_id: united_states.id, user_id: seed_user.id)

ruido = Concert.create(name: 'RuidoFest', votes: 0, street_address: '1301 W. 14th St', 
  zip: '60608', genre_id: ethnic.id, venue_id: addams_medill_park.id, city_id: chicago.id, state_id: illinois.id,
  country_id: united_states.id, user_id: seed_user.id)

pitchfork = Concert.create(name: 'Pitchfork', votes: 0, street_address: '1501 W Randolph St', 
  zip: '60607', genre_id: other.id, venue_id: union_park.id, city_id: chicago.id, state_id: illinois.id,
  country_id: united_states.id, user_id: seed_user.id)

riot = Concert.create(name: 'Riot Fest', votes: 0, street_address: '1401 S Sacramento Dr', 
  zip: '60623', genre_id: multiple.id, venue_id: douglas_park.id, city_id: chicago.id, state_id: illinois.id,
  country_id: united_states.id, user_id: seed_user.id)
  

# Comments

c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: lollapalooza.id, commentable_type: 'Concert'
c.parse_symbols
c.save
  
c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: spring_awakening.id, commentable_type: 'Concert'
c.parse_symbols
c.save
  
c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: wavefront.id, commentable_type: 'Concert'
c.parse_symbols
c.save
 
c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: north_coast.id, commentable_type: 'Concert'
c.parse_symbols
c.save

c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: b96_summer_bash.id, commentable_type: 'Concert'
c.parse_symbols
c.save
  
c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: chicago_blues_festival.id, commentable_type: 'Concert'
c.parse_symbols
c.save
  
c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: chicago_jazz_festival.id, commentable_type: 'Concert'
c.parse_symbols
c.save
  
c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: lakeshake.id, commentable_type: 'Concert'
c.parse_symbols
c.save
  
c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: ruido.id, commentable_type: 'Concert'
c.parse_symbols
c.save
  
c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: pitchfork.id, commentable_type: 'Concert'
c.parse_symbols
c.save
  
c = Comment.create username: 'World', content: 'Hello @World!', user_id: seed_user.id, 
  commentable_id: riot.id, commentable_type: 'Concert'
c.parse_symbols
c.save  