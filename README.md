# Welcome to tuneaddicts

  The purpose of this website is to create a fun and engaging place for people to explore, share, and vote for their favorite or most hated live music experiences. The app is in its development phase but I have [**uploaded**](http://tuneaddicts.herokuapp.com) a stable build to Heroku and populated it with data to highlight the app's purpose and features. Check it out!
  
## Features

### Guest User Accounts

  You will automatically be assigned a guest account when visiting the website. This account will be terminated with the current session. The purpose of the guest account is to provide an easy way for new users to quickly get involved in the comments. A guest user can create comments, but cannot create productions, concerts, videos, or ratings.
  
### User Registration

  User registration is implemented using the Devise gem and its email authentication is up and running. Registered users
  are automatically given a unique profile. The profile page is currently fairly basic but I hope to spice it up soon.
  
### Productions

  Productions, along with concerts, are at heart of the app. A production can represent a festival or an artist's live music events. Productions are composed of concerts. Concerts are the actual events that users will have attended. The scores for a production are derived by averaging all the scores from its concerts with the total number of votes for that production. A registered user can cast one vote for each concert. This means they can have multiple votes per production. Defining and naming what a production and concert should encompass has proven to be challenging and I'm still working on improving their structure.

### Concerts

  The other half of the app's heart are concerts. Concerts are created through a production. These concerts then belong to and make up a part of that production. Registered users can create and cast their votes for concerts. Concerts are the only resource that users can rate. A production's ratings are derived from the scores users give to its concerts.

### Ratings

  Registered users can rate concerts. After a user casts their first vote for a concert, a rating for that concert will be created and associated with that user. There are four rating categories to vote for. "The People": how fun are your fellow concert goers? "The Music": is the music consistent with the quality you expected? "The Venue": does the venue enhance or diminish your fun? "The Atmosphere": how are the ambience and other intangibles that make up part of the concert experience?

### Videos

  Registered users can submit URLs to Youtube videos from a production's page. The video(s) will then be embedded onto the production's page. More video hosting providers will be supported soon.

### Comments

  Guests can make comments but that's the extent of their writing power over the database. If a guest makes a comment and then logs in during the same session, the registered account will take ownership over the guest comment(s).
  
  To create a more interactive commenting system, all comments are parsed. The purpose of the parser is to turn words that conform to a special format into engaging links. Two kinds of references are currently supported, username and video. A video reference looks like *`Video_1`*. The parser extracts the number, in this case `1`, and searches for a video with that `id` in the database. If the video is found, the word will be turned into a link. For example, *`Video_1`* will be output as [Video_1][Arbitrary video reference output]. A username reference looks like *@username*. If the username exists, the word will be turned into a link. For example, *@admin* will be output as [@admin][Arbitrary user reference output]. Punctuation marks can be included with the references. Thus, the following are all valid: *@admin,*, *@admin!*, and *`Video_3`!*. These would be parsed and turned into [@admin][Arbitrary user reference output], [@admin!][Arbitrary user reference output] and [Video_3!][Arbitrary video reference output] respectively.

### Notifications

  A notification is created when a user references another user in a comment. The notification is displayed at the bottom of the referenced user's profile page.