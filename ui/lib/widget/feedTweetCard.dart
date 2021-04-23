import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/models/TweetModel.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/providers/userProvider.dart';
import 'package:ui/screen/pageviews/writeTweetScreen.dart';

class FeedTweetCard extends StatefulWidget {

  final TweetModel tweet;

  FeedTweetCard({this.tweet}) ;

  @override
  _FeedTweetCardState createState() => _FeedTweetCardState();
}

class _FeedTweetCardState extends State<FeedTweetCard> { 

   



  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final List<UserModel> userList = userProvider.getUserList;
    UserModel user = userList.firstWhere((element) => element.uid == widget.tweet.type);
  return   Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         
          Divider(color: Colors.white38,),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("${user.photoUrl}"),
              ),
              SizedBox(width: 10,),
              Text("${user.username}" , style: TextStyle(color: Colors.white , fontSize: 15), )
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            child: Text(widget.tweet.content ,
            style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

Widget CardIcon(Icon icon , int num) {

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(onPressed: () {}, icon: icon , color: Colors.white,),
      Text("${num.toString()}" , style: TextStyle(color: Colors.white),)
    ],
  );

}