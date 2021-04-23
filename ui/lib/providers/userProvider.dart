

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/models/TweetModel.dart';
import 'package:ui/models/tags.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/resources/authMethods.dart';
import 'package:ui/resources/friendDetailsMethods.dart';
import 'package:ui/resources/tweetMethods.dart';

class UserProvider with ChangeNotifier {
  UserModel _user;
  AuthMethods _authMethods = AuthMethods();
  TweetMethods _tweetMethods = TweetMethods();
  FriendMethods _friendMethods = FriendMethods();
  
  Set<String> tweetUIDs = {};
    Set<String> userUIDS = {};
    Set<String> followers = {};
    Set<String> following = {};
    List<TweetModel> usertweets = [];
    List<TopTags> topHashTagsArray = [];
    List<UserModel> userList = [];
    List<TweetModel> feedTweetsList = [];
 

  UserModel get getUser => _user;
  List<UserModel> get getUserList => userList;
  List<TweetModel> get getUserTweet => usertweets;
  Set<String> get getFollowers => followers;
  Set<String> get getFollowing => following;
  List<TweetModel> get getFeedTweets => feedTweetsList;

  Future<void> refreshUserDetails(String uid) async {
   
   UserModel user =  await _authMethods.getEverythingAboutUser(uid);
   _user = user;
   notifyListeners();
     
  }

  Future<void> getUserTweets(String uid) async{
  
   

    usertweets = await _tweetMethods.getUserTweet(uid);
    notifyListeners();

  }
 

 Future<bool> writeUserTweet(String user_id , String content) async {
  
  bool isTrue = false;
   await _tweetMethods.postTweet(user_id, content).then((String val) {
     if(val != null){
        TweetModel tweet = TweetModel(
          type: 'by_user',
          content: content,
          uuid: val
        );
        isTrue = true;
        usertweets.insert(0, tweet);
        notifyListeners();
     
     }

   });
    return isTrue;
 }

 Future<void> generateFeedForUser(String uid) async {

   _tweetMethods.generateFeed(uid).then((List<dynamic> value) => {
     value.forEach(( data ) { 
      data['f'].forEach( (tweet) {
        if(!tweetUIDs.contains(tweet['tweet_uid'])){
          tweetUIDs.add(tweet['tweet_uid']);
          feedTweetsList.add(TweetModel.fromMap(tweet));
        }
       
      } );
     })

   });
    notifyListeners();
 }

 Future<void> addhashName(String text) async {
   RegExp exp = new RegExp(r"\B#\w\w+");
  
  exp.allMatches(text).forEach((tag) async { 
    await _tweetMethods.addTags(tag.group(0));
  });

 }


Future<void> followUser(String person_uid) async {
  following.add(person_uid);
  notifyListeners();
}

Future<void> unFollowUser(String person_uid) async {
  following.remove(person_uid);
  notifyListeners();
}


  Future<void> updatePhotoUrl(String url , String user_uid) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('photoUrl', url);
    _user.photoUrl = url;


    await _authMethods.changePhotoUrl(user_uid, url);
    notifyListeners();
  }

  Future<void> fetchAllUsers(String uid) async {
   
    List<UserModel> addUsers = [];
    

    await _authMethods.fetchAllUsers().then((value) => {
       for(var i = 0 ; i<value.length ; i++){
         if(value[i]['user_uid'] != uid && !userUIDS.contains(value[i]['user_uid'])){
           userUIDS.add(value[i]['user_uid']),
           userList.add(UserModel.fromMap(value[i]))
         }
       }
    });

    notifyListeners();
    


  }

    Future<void> updateFriendsDetails( String user_uid) async {

 

    await _friendMethods.getFriendsDetails(user_uid).then((Map<String , dynamic> value) {
     
      value['followers'].forEach((element) {
        followers.add(element);
      });
      
      value['following'].forEach((element) {
        following.add(element);
      });
     
 
    });
   notifyListeners();
  }





Future<void> topHashTags() async {
 _tweetMethods.topTags().then(( List<TopTags> data) => {
     topHashTagsArray = data
 }
 
 ) ;

 notifyListeners();

}

Future<bool> updateDetails(String name , String username , String bio , String user_uid) async {
  
  _user.name = name;
  _user.bio = bio;
  _user.username = username;
   bool isTrue = false;
  await _authMethods.updateUserDetails(name, username, bio, user_uid).then((bool val) {
    if(val){
      
      isTrue = true;
    }

    
  });
  notifyListeners();
  return isTrue;
}




}