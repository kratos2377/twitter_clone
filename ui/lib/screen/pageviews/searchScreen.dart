import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/models/tags.dart';
import 'package:ui/providers/tweetProvider.dart';
import 'package:ui/screen/pageviews/search_user.dart';
import 'package:ui/utils/universal_variables.dart';
import 'package:ui/widget/topHashTags.dart';


class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  
  List<TopTags> topHashTags ;


  @override
  Widget build(BuildContext context) {
    final TweetProvider _tweetProvider = Provider.of<TweetProvider>(context);
    setState(() {
      topHashTags = _tweetProvider.getTopTags;
    });

    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(backgroundColor: UniversalVariables.blackColor,),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchUserScreen()));
              },
              child: Container(
              decoration: BoxDecoration(color: Colors.white38 , borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey , width: 2.0 , style: BorderStyle.solid) 
              ),
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search , color: Colors.white54),
                  SizedBox(width: 5,),
                  Text("Search" , style: TextStyle(color: Colors.white54),)
                ],),
            )),

            if(topHashTags.length == 0) Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                padding: EdgeInsets.all(10),
                child: Text("Nothing Interesting Happening Go And Study For ETE Dumbass" , style: TextStyle(color: Colors.white),),
              ),
            )
             else for(var i = 0 ; i<topHashTags.length ; i++) Column(mainAxisSize: MainAxisSize.min,
              children: [
                Divider(color: Colors.white38,),
                TopHashTags(tag: topHashTags[i], index: i+1),
              ],
              )
          ],
        ),
      ),
    );
  }
}