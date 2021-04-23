import 'package:flutter/material.dart';
import 'package:ui/models/tags.dart';
import 'package:ui/utils/universal_variables.dart';


class TopHashTags extends StatefulWidget {

  final TopTags tag;
  final int index;

   TopHashTags({this.tag , this.index}) ;

  @override
  _TopHashTagsState createState() => _TopHashTagsState();
}

class _TopHashTagsState extends State<TopHashTags> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: UniversalVariables.blackColor,
      elevation: 3,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(shape: BoxShape.circle , 
            border: Border.all(color: Colors.white , width: 1.0 , style: BorderStyle.solid)
            ),

            child: Text("${widget.index.toString()}" , style: TextStyle(color: Colors.white , fontSize: 30),),
          ),
          title: Text("${widget.tag.hashtagname}" , overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white),
          ),
          subtitle: Text("${widget.tag.numberoftweets.toString()} Tweets" , style: TextStyle(color: Colors.blue),),
        )
      ),
    );
  }
}