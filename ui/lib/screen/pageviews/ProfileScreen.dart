
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/loginAndRegister.dart';
import 'package:ui/models/TweetModel.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/providers/tweetProvider.dart';
import 'package:ui/providers/userProvider.dart';
import 'package:ui/screen/pageviews/edit_profile_screen.dart';
import 'package:ui/screen/pageviews/writeTweetScreen.dart';
import 'package:ui/utils/universal_variables.dart';
import 'package:ui/widget/tweetCard.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  bool loading = true;
  bool tweetsNotLoaded = true;
 
  String photoUrl;
  String name;
  String username;
  String bio;
  String id;

  // @override
  // void initState()  {
  //   // TODO: implement initState
  //   super.initState();


  
  //  SchedulerBinding.instance.addPostFrameCallback((_) async {

  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //  setState(() async {
  //     id =  await prefs.getString('_id');
  //     name = await prefs.getString('name');
  //     username = await prefs.getString('username');
  //     bio = await prefs.getString('bio');
  //     photoUrl = await prefs.getString('photoUrl');
  //  });
  //   });

 
  // }
  // 
   void _showLogoutDialog() {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Logout"),
        content: new Text("Are Your Sure You Want To Logout?"),
        actions: [
         new TextButton(onPressed: () async {
           SharedPreferences prefs = await SharedPreferences.getInstance();
           prefs.remove('_id');

                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginAndRegisterScreen()));
                  }, child: Text("Yes" , style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold),)),
               new   TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("No" , style: TextStyle(color: Colors.red , fontWeight: FontWeight.bold),))
        ],
      );

    });
  }


  @override
  Widget build(BuildContext context) {
   final UserProvider  _userProvider = Provider.of<UserProvider>(context);
    
  //  tweetsForProfile.addAll( _tweetProvider.usetTweets);
  //  tweetsForProfile.addAll( _userProvider.tweets) ;
 final UserModel user = _userProvider.getUser;
 final List<TweetModel> userTweets = _userProvider.getUserTweet;
 final Set<String> followers = _userProvider.getFollowers;
 final Set<String> following = _userProvider.getFollowing;
 
  setState(() {
    loading = false;
  });

  setState(() {
    tweetsNotLoaded = false;
  });

    return loading ? Center(child: CircularProgressIndicator(),) : Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(backgroundColor: UniversalVariables.blackColor,
      title: Text("${user.username}" , style: TextStyle(color: Colors.white),),
      actions: [
        IconButton(icon: Icon(Icons.text_fields), onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (context) => WriteTweetScreen()))),
        IconButton(onPressed: () => _showLogoutDialog(), icon: Icon(Icons.logout))
      ],

      
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 20,),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/4,
                  child: CircleAvatar(
                    
                    radius: 40,
                    backgroundImage: NetworkImage("${user.photoUrl}"),
                  ),
                ),
                Container(
                   width: MediaQuery.of(context).size.width * 0.75,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn("Tweets", userTweets.length),
                    _buildStatColumn("Following", following.length),
                    _buildStatColumn("Followers", followers.length),
                  ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20 , horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Text("${user.bio}", style: TextStyle(color: Colors.white),),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white , width: 1.0 , style: BorderStyle.solid),
              color: Colors.lightBlueAccent
               ),
              margin: EdgeInsets.symmetric(vertical: 5 , horizontal: 10),
              child: TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileScreen() )),
               child: Text("Edit Profile" , style: TextStyle(color: Colors.white),)),
            ),

            if(tweetsNotLoaded)  Center(child: CircularProgressIndicator(),) 
            else  userTweets.length == 0 ? Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   Text("You Have No Tweet Yet" , style: TextStyle(color: Colors.white),),
                   TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => WriteTweetScreen())), 
                   child: Text("Write A Tweet" , style: TextStyle(color: Colors.amber),) )
                ],
              ),
            ) :  ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
                itemBuilder: (context , i) => TweetCard(user: user, tweet: userTweets[i],),
              itemCount: userTweets.length,
               ),
            
            
          
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