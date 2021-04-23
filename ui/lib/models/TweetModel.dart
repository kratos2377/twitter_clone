

import 'package:ui/models/Comment.dart';
import 'package:uuid/uuid.dart';

class TweetModel {
   
    String content;
    String type;
    String uuid;
    int retweet;

  TweetModel({this.content, this.type, this.uuid , this.retweet = 0});

   
    TweetModel.fromMap(Map<String, dynamic> mapData) {
    this.content = mapData['tweet_content'];
    this.uuid = mapData['tweet_uid'];
    this.type = mapData['type_of'];
  }

  TweetModel.fromDoc(Map<String,dynamic> mapData){
     this.retweet = mapData['retweet'];
  }


}