import 'dart:html';

import 'package:flutter/material.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/screen/pageviews/edit_profile_screen.dart';
import 'package:ui/utils/universal_variables.dart';
import 'package:ui/widget/tweetCard.dart';


class UserScreen extends StatefulWidget {

  final UserModel user;

   UserScreen(this.user);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(title: Text(widget.user.username , style: TextStyle(color: Colors.white,),),
      leading: IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back)),
      actions: [
        TextButton(onPressed: () {}, child: Text("Follow" , style: TextStyle(color: Colors.blue),))
      ],
      ),

      body:  SingleChildScrollView(
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
                    backgroundImage: NetworkImage(widget.user.photoUrl),
                  ),
                ),
                Container(
                   width: MediaQuery.of(context).size.width * 0.75,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn("Tweets", 20),
                    _buildStatColumn("Following", 120),
                    _buildStatColumn("Followers", 200),
                  ],
                  ),
                )
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Text(widget.user.bio , style: TextStyle(color: Colors.white),),
            ),
           

            for(var i = 0 ; i<20 ; i++) TweetCard()
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