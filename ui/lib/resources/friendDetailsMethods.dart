
import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

class FriendMethods {

  Dio dio = new Dio();
    
    final String mainUrl = "http://localhost:5000";

    Future<bool> followPerson(String user_uid , String person_uid) async {
     final url = "$mainUrl/friends/follow";

     try{
         final response = await dio.post(url , 
         
         data: {
           "person_uid": person_uid,
           "user_uid":user_uid
         },

         options: Options(contentType: Headers.formUrlEncodedContentType)
         
         ); 

         if(response.data['success']){
           return true;
         }

         return false;
     } catch(err) {
       throw err;
     }
    }

      Future<bool> unfollowPerson(String user_uid , String person_uid) async {
     final url = "$mainUrl/friends/unfollow";

     try{
         final response = await dio.post(url , 
         
         data: {
           "person_uid": person_uid,
           "user_uid":user_uid
         },

         options: Options(contentType: Headers.formUrlEncodedContentType)
         
         ); 

         if(response.data['success']){
              return true;
         }

         return false;
     } catch(err) {
       throw err;
     }
    }

    Future<Map<String , dynamic>> getFriendsDetails(String uid) async {

     final String url = "$mainUrl/friends/getDetails";

     try {


       final response = await dio.post(url , 
       
       data: {
         "user_uid": uid
       },
     options: Options(contentType: Headers.formUrlEncodedContentType)
       );

       if(response.data['success']){
         return response.data['data'];
       }

       return  {};

     } catch(err){
       throw err;
     }



    }


}