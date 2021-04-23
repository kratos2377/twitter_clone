
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/models/TweetModel.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/providers/userProvider.dart';
import 'package:ui/resources/friendDetailsMethods.dart';
import 'package:ui/resources/tweetMethods.dart';
import 'package:ui/screen/pageviews/edit_profile_screen.dart';
import 'package:ui/utils/universal_variables.dart';
import 'package:ui/widget/tweetCard.dart';

class PersonProfileScreen extends StatefulWidget {
 
  final UserModel reciever;

   PersonProfileScreen({this.reciever}) ;

  @override
  _PersonProfileScreenState createState() => _PersonProfileScreenState();
}

class _PersonProfileScreenState extends State<PersonProfileScreen> {
  
  bool loading = true;
  bool tweetsNotLoaded = true;
  bool statsLoaded = false;
  List<TweetModel> tweetsForProfile = [];
  FriendMethods _friendMethods = FriendMethods();
  TweetMethods _tweetMethods = TweetMethods();
  String uid;
  List<TweetModel> tweetListofPerson;
 Set<String> personFollowList;
  Set<String> personFollowingList;


  @override
  void initState() { 
    super.initState();
        SchedulerBinding.instance.addPostFrameCallback((_) async { 
       Set<String> followersList = {};
       Set<String> followingList = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      uid = prefs.getString('_id');
    });

      tweetListofPerson =  await _tweetMethods.getUserTweet(widget.reciever.uid);
       Map<String , dynamic> mapData = await _friendMethods.getFriendsDetails(widget.reciever.uid);
       
                 mapData['followers'].forEach((uid) {
             followersList.add(uid);
        });
        mapData['following'].forEach((uid) {
             followingList.add(uid);
        });

        setState(() {
                  personFollowList = followersList;
                  personFollowingList = followingList;
                });

                  setState(() {
    loading = false;
  });

     setState(() {
      tweetsNotLoaded  = false;
    });

    setState(() {
          statsLoaded = true;
        });

           

    
   });

      
  }


void unFollowUser() {
 _friendMethods.unfollowPerson(uid, widget.reciever.uid);
}

void followUser() async {
   await _friendMethods.followPerson(uid, widget.reciever.uid);
}


  @override
  Widget build(BuildContext context) {
   

    final UserProvider _userProvider = Provider.of<UserProvider>(context);
    final Set<String> followingList = _userProvider.getFollowing;
    
              print("PROFILE FRIENDS DATA IS HERE");
              print(personFollowList);
              print(personFollowingList);

 

   

    bool doIfollowUser = followingList.contains(widget.reciever.uid);

 

  setState(() {
      
    });

    return loading ? Center(child: CircularProgressIndicator(),) : Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(backgroundColor: UniversalVariables.blackColor,
      title: Text("${widget.reciever.username}" , style: TextStyle(color: Colors.white),),
      actions: [
        // IconButton(onPressed: () {}, icon: Icon(Icons.settings))
        doIfollowUser ? TextButton(onPressed: () {
           setState(() {
             doIfollowUser = false;
           });
          
           _userProvider.unFollowUser(widget.reciever.uid);
           unFollowUser();
          
        }, child: Text("Unfollow" , style: TextStyle(color: Colors.red , fontSize: 20),)) :
         TextButton(onPressed: () {
             setState(() {
             doIfollowUser = true;
           });
             _userProvider.followUser(widget.reciever.uid);
           followUser();
         
         }, child: Text("Follow" , style: TextStyle(color: Colors.blue , fontSize: 20),))
      ],

      
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: CircleAvatar(
                    
                    radius: 40,
                    backgroundImage: NetworkImage("${widget.reciever.photoUrl}"),
                  ),
                ),
               statsLoaded ? Container(
                   width: MediaQuery.of(context).size.width * 0.75,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn("Tweets", tweetListofPerson != null ? tweetListofPerson.length : 0),
                    _buildStatColumn("Following", personFollowingList != null ? personFollowingList.length : 0),
                    _buildStatColumn("Followers", personFollowList != null ? personFollowList.length : 0),
                  ],
                  ),
                ) : JumpingDotsProgressIndicator(
            
                  fontSize: 40.0,
                  color: Colors.white,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20 , horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Text("${widget.reciever.name}", style: TextStyle(color: Colors.white),),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20 , horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Text("${widget.reciever.bio}", style: TextStyle(color: Colors.white),),
            ),

            if(tweetsNotLoaded)  Center(child: CircularProgressIndicator(),) 
            else tweetListofPerson.length == 0 ? Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
              children: [
                   Text("User Has No Tweet" , style: TextStyle(color: Colors.white),),
                ],
              ),
            ) : ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context , i) => TweetCard(user: widget.reciever, tweet: tweetListofPerson[i],),
            itemCount: tweetListofPerson.length,
             )
            
          ],
        ),
      ) ,
    );
  }
}


Column _buildStatColumn(String label , int number){
   return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            number.toString(),
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold , color: Colors.white),
          ),
          Container(
              margin: const EdgeInsets.only(top: 4.0),
              child: Text(
                label,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400),
              ))
        ],
      );
}