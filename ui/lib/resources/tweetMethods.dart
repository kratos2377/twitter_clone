

import 'package:dio/dio.dart';
import 'package:ui/models/TweetModel.dart';
import 'package:ui/models/tags.dart';

class TweetMethods {
  
  Dio dio = new Dio();
  
  final String mainUrl = "http://localhost:5000";

  Future<String> postTweet(String user_uid , String content) async {

    final String url = "$mainUrl/tweet/user";
try  {
  
    final response = await dio.post(url ,
     
     data: {
        "user_uid": user_uid,
        "content": content
     },
      options: Options(contentType: Headers.formUrlEncodedContentType)
    
     );


     if(response.data['success']){
      return response.data['data'];
     }

     return null;
} catch(err) {
  throw err;
}

  }

   Future<Map<String , dynamic>> shareTweet(String user_uid , String tweet_id) async {

    final String url = "$mainUrl/tweet/share";
try  {
  
    final response = await dio.post(url ,
     
     data: {
        "user_uid": user_uid,
        "tweet_id": tweet_id
     },
      options: Options(contentType: Headers.formUrlEncodedContentType)
    
     );


     if(response.data['success']){
      

      return response.data['data'];
     }

     return {};
} catch(err) {
  throw err;
}

  }


   Future<List<TweetModel>> getUserTweet(String user_uid ) async {

    final String url = "$mainUrl/tweet/getTweets";
    final List<TweetModel> data = [];
try  {
  
    final response = await dio.post(url ,
    data: {
      "user_uid":user_uid
    },
      options: Options(contentType: Headers.formUrlEncodedContentType)
    
     );


     if(response.data['success']){
      
      response.data['data'].forEach((value) {
        data.add(TweetModel.fromMap(value));
      });



      return data;
     }


     return [];
} catch(err) {
  throw err;
}

  }


    Future<void> addTags(String hashtags) async {
    final url = "$mainUrl/tweet/addTag";
   
         try{
       final response = await dio.post(url , 
       data: {
         "hash_names": hashtags
       },
       options: Options(contentType: Headers.formUrlEncodedContentType)
        );
         } catch(err){
           throw err;
         }
   

  }

  Future<List<dynamic>> generateFeed(String uid) async {
    final url = "$mainUrl/tweet/getFeed";

    try {
        final response = await dio.post(url , 
        data: {
          "user_uid" : uid
          
               },
           options: Options(contentType: Headers.formUrlEncodedContentType)    
               );

               if(response.data['success']){
                 return response.data['data'];
               }

               return [];
    } catch(err){
      throw err;
    }
  }


  Future <List<TopTags>> topTags() async {
     final String url = "$mainUrl/tweet/getTopTweets";
     List<TopTags> data = [];
    try {
      final response = await dio.post(url , 
      
      options: Options(contentType: Headers.formUrlEncodedContentType)
       );

       if(response.data['success']){

         response.data['data'].forEach( (element)  {
             TopTags tags = TopTags.fromMap(element);
             data.add(tags);

         } );
         return data;
       }

       return [];
    } catch(err){
      throw err;
    }
  }



}