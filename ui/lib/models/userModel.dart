
import 'package:uuid/uuid.dart';

class UserModel {
  
   String name;
   String email;
   String token;
   String uid;
   String username;
   String photoUrl;
   String bio;
   List<String> followers;
   List<String> following;
  

  UserModel({this.name, this.email, this.token, this.uid , this.photoUrl , this.bio, this.username , this.followers = const [] , this.following = const []});
  
  UserModel.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['user_uid'];
    this.name = mapData['user_real_name'];
    this.email = mapData['email'];
    this.bio = mapData['bio'];
    this.username = mapData['user_name'];
    this.photoUrl = mapData['photourl'];
  }

  UserModel.fromDoc(Map<String , dynamic> mapData){
     this.uid = mapData['_id'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.bio = mapData['bio'];
    this.username = mapData['username'];
    this.photoUrl = mapData['photoUrl'];
  }

}