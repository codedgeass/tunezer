# Welcome to tunezer

  The purpose of this website is to create a fun and engaging place for people to explore, share, and vote for their most loved, most hated, and most debated live music experiences. [**Check it out!**](http://tunezer.com).
  
## Features

### Guest User Accounts

  You will automatically be assigned a guest account when visiting the website. This account will be terminated with the current session. The purpose of the guest account is to provide an easy way for new users to quickly get involved in the comments. A guest user can create comments, but cannot create concerts, concerts, videos, or ratings.
  
### User Registration

  User registration is implemented using the Devise gem and its email authentication is up and running. Registered users
  are automatically given a unique profile. The profile page is currently fairly basic but I hope to spice it up soon.
  
### Concerts

  Concerts are the heart of the app. Concerts are actual live music events that users will have attended. The scores for a concert are derived by averaging all the ratings users have cast with the total number of votes for that concert. A registered user can cast one vote for each concert.

### Ratings

  Registered users can rate concerts. After a user casts their first vote for a concert, a rating for that concert will be created and associated with that user. The rating will not be counted until the user has voted for all four categories. There are four rating categories to vote for. "The People": how fun are your fellow concert goers? "The Music": is the music consistent with the quality you expected? "The Venue": does the venue enhance or diminish your fun? "The Atmosphere": how are the ambience and other intangibles that make up part of the concert experience?

### Videos

  Registered users can submit URLs to Youtube videos from a concert's page. The video(s) will then be embedded onto the concert's page. More video hosting providers will be supported soon.

### Comments

  Guests can make comments but that's the extent of their writing power over the database. If a guest makes a comment and then logs in during the same session, the registered account will take ownership over the guest comment(s).
  
  To create a more interactive commenting system, all comments are parsed. The purpose of the parser is to turn words that conform to a special format into engaging links. Two kinds of references are currently supported, username and video. A video reference looks like *\`Video_1\`*. The parser extracts the number, in this case `1`, and searches for a video with that `id` in the database. If the video is found, the word will be turned into a link. For example, *\`Video_1\`* will be output as [Video_1][1]. A username reference looks like *@username*. If the username exists, the word will be turned into a link. For example, *@admin* will be output as [@admin][1]. Punctuation marks can be included with the references. Thus, the following are all valid: *@admin,*, *@admin!*, and *\`Video_3\`!*. These would be parsed and turned into [@admin][1], [@admin!][1] and [Video_3!][1] respectively.

### Notifications

  A notification is created when a user references another user in a comment. The notification is displayed at the bottom of the referenced user's profile page.
  
[1]: google.com