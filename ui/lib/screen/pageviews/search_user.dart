import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/providers/userProvider.dart';
import 'package:ui/resources/authMethods.dart';
import 'package:ui/screen/pageviews/person_profile_screen.dart';
import 'package:ui/utils/universal_variables.dart';
import 'package:ui/widget/custom_tile.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

class SearchUserScreen extends StatefulWidget {

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
 
 
 List<UserModel> userList ;

 

  TextEditingController searchController = TextEditingController();
  String query = "";
  bool loaded = false;


    searchAppBar(BuildContext context) {
   
      
      return NewGradientAppBar(
       gradient: LinearGradient(colors: [UniversalVariables.gradientColorStart, UniversalVariables.gradientColorEnd]),
       leading: IconButton(
         icon: Icon(Icons.arrow_back , color: Colors.white),
         onPressed: () => Navigator.pop(context)
       ),
       elevation: 0,
       bottom: PreferredSize(
         preferredSize: const Size.fromHeight(kToolbarHeight + 20),
         child: Padding(padding: EdgeInsets.only(left: 20),
         child: TextField(
           controller: searchController,
           onChanged: (val) {
             setState(() {
               query = val;
             });
           },
           cursorColor: UniversalVariables.blackColor,
           autofocus: true,
           style: TextStyle(
             fontWeight: FontWeight.bold,
             color: Colors.white,
             fontSize: 35
           ),
           decoration: InputDecoration(
             suffixIcon: IconButton(icon: Icon(Icons.close , color: Colors.white),
             onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) => searchController.clear());
             },
             ),
             border: InputBorder.none,
             hintText: "Search",
             hintStyle: TextStyle(
               fontWeight: FontWeight.bold,
               fontSize: 35,
               color: Color(0x88ffffff),

             )
           ),
         )
         )
       ),
      );
    }

  buildSuggestions(String query) {
   
   final List<UserModel> suggestionList = query.isEmpty ? [] : userList != null
            ? userList.where((UserModel user) {
                String _getUsername = user.username.toLowerCase();
                String _query = query.toLowerCase();
                String _getName = user.name.toLowerCase();
                bool matchesUsername = _getUsername.contains(_query);
                bool matchesName = _getName.contains(_query);

                return (matchesUsername || matchesName);

                // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
                //     (user.name.toLowerCase().contains(query.toLowerCase()))),
              }).toList()
            : [];
   
   return ListView.builder(
     itemCount: suggestionList.length,
     itemBuilder: ( (context , index) {
       UserModel searchUser = UserModel(
         uid: suggestionList[index].uid,
         photoUrl: suggestionList[index].photoUrl,
         name: suggestionList[index].name,
         username: suggestionList[index].username,
         bio: suggestionList[index].bio,
         email: suggestionList[index].email,
       );

       return CustomTile(
         mini: false,
         onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PersonProfileScreen(reciever: searchUser,)));
         },
         leading: CircleAvatar(
           backgroundImage: NetworkImage(searchUser.photoUrl),
           backgroundColor: Colors.grey,

         ),
         title: Text(searchUser.name , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold,)),
         subtitle: Text(searchUser.name , style: TextStyle(color: UniversalVariables.greyColor)),
       );
     }),
   );

  }





  @override
  Widget build(BuildContext context) {
     final UserProvider _userProvider = Provider.of<UserProvider>(context);
     setState(() {
       userList = _userProvider.userList;
     });
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }
}