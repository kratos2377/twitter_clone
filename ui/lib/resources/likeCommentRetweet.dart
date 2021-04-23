



import 'package:dio/dio.dart';

class TweetOperations {

  Dio dio = new Dio();

  final String mainUrl = "";


  Future<bool> likeTweet(String tweet_id , String user_uid) async {

    final String url = "$mainUrl/tweetOp/like";

  try {
       final response = await dio.post(url ,
     data: {
       "tweet_id": tweet_id,
       "user_uid": user_uid
     },

     options: Options(contentType: Headers.formUrlEncodedContentType)
     
      );

      if(response.data['success']) {
        
      }
  } catch(err){
    throw err;
  }

  }
  Future<bool> commentOnTweet(String tweet_id , String user_uid , String content) async {

    final String url = "$mainUrl/tweetOp/comment";

  try {
       final response = await dio.post(url ,
     data: {
       "tweet_id": tweet_id,
       "user_uid": user_uid,
       "content": content
     },

     options: Options(contentType: Headers.formUrlEncodedContentType)
     
      );

      if(response.data['success']) {

      }
  } catch(err){
    throw err;
  }

  }
  Future<bool> retweetTweet(String tweet_id , String user_uid) async {

    final String url = "$mainUrl/tweetOp/like";

  try {
       final response = await dio.post(url ,
     data: {
       "tweet_id": tweet_id,
       "user_uid": user_uid
     },

     options: Options(contentType: Headers.formUrlEncodedContentType)
     
      );

      if(response.data['success']) {

      }
  } catch(err){
    throw err;
  }

  }


}