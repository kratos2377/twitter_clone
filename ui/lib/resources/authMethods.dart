import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/providers/userProvider.dart';

class AuthMethods {


  Dio dio = new Dio();

  final String mainUrl = "http://localhost:5000";
    

  Future<bool> login(String email , String password) async {

     final url = '$mainUrl/users/login';
     try {
      
     final response = await dio.post(url ,
      data: {
        "email": email,
        "password": password
      },
      options: Options(contentType: Headers.formUrlEncodedContentType)
      );
    
      if(response.data['success']){
        print("DATA IS HERE");
        print(response.data);
        SharedPreferences prefs = await SharedPreferences.getInstance();
       await prefs.setString('_id', response.data['_id'].toString());
        await prefs.setString('name', response.data['name'].toString());
        await prefs.setString('username', response.data['username'].toString());
        await prefs.setString('token', response.data['token'].toString());
        await prefs.setString('email', response.data['email'].toString());
        await prefs.setString('bio', response.data['bio'].toString());
        await prefs.setString('photoUrl', response.data['photoUrl'].toString());
        return true;
      } 

      return false;

     } on DioError catch (err) {
       print(err);
     }

     
  } 

  Future<bool> register(String email , String password , String username , String name) async {
    
    final url = '$mainUrl/users/register';
    
    try {
        
        final response = await dio.post(url ,
         
         data: {
           "email":email,
           "password": password,
           "username": username,
           "name": name,
         },
         options: Options(contentType: Headers.formUrlEncodedContentType)
         );
     
     
      if(response.data['success']){
      SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('_id', response.data['_id'].toString());
        await prefs.setString('name', response.data['name'].toString());
        await prefs.setString('username', response.data['username'].toString());
        await prefs.setString('token', response.data['token'].toString());
        await prefs.setString('email', response.data['email'].toString());
        return true;
      } 

      return false;

    } on DioError catch(err) {
      print(err);
    }
   
  }



  Future<bool> updateUserDetails(String name , String username , String bio , String user_uid) async {

    final url = "$mainUrl/users/update";

    try {
      final response = await dio.post(url ,
        
        data:  {
          "name":name,
          "username": username,
          "bio": bio,
          "user_uid":user_uid
        },

        options: Options(contentType: Headers.formUrlEncodedContentType)
      
       );
      
      if(response.data['success']){
        return true;
      }

      return false;
   
    } catch(err){
      throw err;
    }

  }

  Future<bool> changePassword(String currentPassword , String newPassword , String user_uid) async {
     
     final url = "$mainUrl/users/changepassword";

     try{
       final response = await dio.post(url , 
       data: {
         "password": currentPassword,
         "newPassword": newPassword,
         "user_uid": user_uid
       },
       options: Options(contentType: Headers.formUrlEncodedContentType)
       );

       if(response.data['success']){
         return true;
       } 

       return false;
     } catch(err){
       throw err;
     }
  }

  Future<bool> changePhotoUrl(String user_uid , String photoUrl) async {
    final url = "$mainUrl/users/changePhoto";

    try {
      final response = await dio.post(url , 
      
      data: {
        "user_uid": user_uid,
        "photoUrl":photoUrl
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


  Future<List<dynamic>> fetchAllUsers() async {

    final url = "$mainUrl/users/getUsers";

   try {
     final response = await dio.post(url);

     if(response.data['success']){
           return response.data['data'];
     } 

     return [];
   } catch(err) {
     throw err;
   }

  }
 

 Future<UserModel> getEverythingAboutUser(String id) async {
    final url = "$mainUrl/users/getUserDet";

    SharedPreferences prefs = await SharedPreferences.getInstance();


   try {
     final response = await dio.post(url , 
     
     data: {
       "user_uid": id
     },

     options: Options(contentType: Headers.formUrlEncodedContentType)
     
     );

     if(response.data['success']){

       UserModel user = UserModel.fromDoc(response.data);
        
    

        return user;
     } 

   } catch(err) {
     throw err;
   }
 }

 Future<void> testRoutes(UserModel dat) async {
   final String url = "$mainUrl/test";

   try{
    final response = dio.post(url , 
    
    data: {
      "uid": dat.uid,
      "name": dat.name,
      "email": dat.email,
      "username": dat.username
    },
    options: Options(contentType: Headers.formUrlEncodedContentType)
     );
   } catch(err){
     throw err;
   }
 }

}