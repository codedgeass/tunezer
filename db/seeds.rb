seed_user = User.new username: 'admin', password: 'admin00', email: 'admin@tunezer.com', admin: true
seed_user.skip_confirmation!
seed_user.save!
Concert.create name: 'Ultra Music Festival', genre: 'Electronic', 
  number_of_votes: 0, location: 'Miami, FL', venue_name: 'Bayfront Park'