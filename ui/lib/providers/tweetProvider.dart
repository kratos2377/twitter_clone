


import 'package:flutter/cupertino.dart';
import 'package:ui/models/TweetModel.dart';
import 'package:ui/models/tags.dart';
import 'package:ui/resources/tweetMethods.dart';

class TweetProvider with ChangeNotifier {
  

  List<TweetModel> usetTweets = [];
  List<TopTags> topHashTags = [];
  TweetMethods _tweetMethods  = TweetMethods();

  List<TopTags> get getTopTags => topHashTags;
  List<TweetModel> get getUserTweets => usetTweets;


 

  Future<void> shareTweet(String user_uid , String tweet_id) async {

 
    _tweetMethods.shareTweet(user_uid, tweet_id).then((Map<String , dynamic> value) => {
      usetTweets.insert(0 ,TweetModel.fromMap(value))
    });

    notifyListeners();

  }

  Future<void> getTopHashTags() async {
        
        _tweetMethods.topTags().then(( List<TopTags> data ) {
          topHashTags = data;
          notifyListeners();
        } );


  }
}