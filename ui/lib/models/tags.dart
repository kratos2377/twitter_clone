

class TopTags {
 
 String hashtagname;
 int numberoftweets;


 TopTags({this.hashtagname , this.numberoftweets});


 TopTags.fromMap(Map<String , dynamic> mapData) {
   this.hashtagname = mapData['hash_name'];
   this.numberoftweets = mapData['number_of_tweets'];
 }
 
}