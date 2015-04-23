seed_user = User.new username: 'admin', password: 'admin00', email: 'admin@tunezer.com', admin: true
seed_user.skip_confirmation!
seed_user.save!
Production.create name: 'Ultra Music Festival', category: 'Festival', genre: 'Electronic', number_of_votes: 0