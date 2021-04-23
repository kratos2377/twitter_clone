import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/models/TweetModel.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/screen/pageviews/writeTweetScreen.dart';

class TweetCard extends StatefulWidget {

  final TweetModel tweet;
  final UserModel user;

  TweetCard({this.tweet , this.user}) ;

  @override
  _TweetCardState createState() => _TweetCardState();
}

class _TweetCardState extends State<TweetCard> { 

   



  @override
  Widget build(BuildContext context) {

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
                backgroundImage: NetworkImage("${widget.user.photoUrl}"),
              ),
              SizedBox(width: 10,),
              Text("${widget.user.username}" , style: TextStyle(color: Colors.white , fontSize: 15), )
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