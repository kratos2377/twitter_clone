
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/providers/tweetProvider.dart';
import 'package:ui/providers/userProvider.dart';
import 'package:ui/screen/pageviews/ProfileScreen.dart';
import 'package:ui/screen/pageviews/feedScreen.dart';
import 'package:ui/screen/pageviews/searchScreen.dart';
import 'package:ui/screen/pageviews/search_user.dart';
import 'package:ui/utils/universal_variables.dart';
import 'package:fluentui_icons/fluentui_icons.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  PageController pageController = PageController();
  int _page = 0;
  bool notLoaded = true;
  UserProvider _userProvider ;
  TweetProvider _tweetProvider;
  String uid;
  List<UserModel> userList;


  @override
  Widget build(BuildContext context)  {

  
   void onPageChanged(int page) {
    setState(() {
          _page = page;
        });
  }

   
   void navigationTapped(int page) {
   pageController.jumpToPage(page);
   }

   void pageChanger(int page){
    setState(() {
          _page = page;
        });

        navigationTapped(page);
   }
    double labelFontSize = 10;


    return Scaffold(
        backgroundColor: UniversalVariables.blackColor,
     

        bottomNavigationBar: Container(
        child: Padding(
           padding: EdgeInsets.symmetric(vertical: 10),
            child: CupertinoTabBar(
backgroundColor: UniversalVariables.blackColor,
items: <BottomNavigationBarItem>[
  BottomNavigationBarItem(icon: Icon(Icons.feedback ,
   color: (_page == 0) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor , 
  ),
  title: Text("Feed" , style: TextStyle( fontSize: labelFontSize , color: (_page == 0) ?
   UniversalVariables.lightBlueColor : UniversalVariables.greyColor  ) )
  ),


  BottomNavigationBarItem(icon: Icon(Icons.search ,
   color: (_page == 1) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor , 
  ),
  title: Text("Search" , style: TextStyle( fontSize: labelFontSize , color: (_page == 1) ?
   UniversalVariables.lightBlueColor : UniversalVariables.greyColor  ) )
  ),


  BottomNavigationBarItem(icon: Icon(Icons.person ,
   color: (_page == 2) ? UniversalVariables.lightBlueColor : UniversalVariables.greyColor , 
  ),
  title: Text("Profile" , style: TextStyle( fontSize: labelFontSize , color: (_page == 2) ?
   UniversalVariables.lightBlueColor : UniversalVariables.greyColor  ) )
  ),
],

onTap: navigationTapped,
currentIndex: _page,
        ),
        )
       
       
      ),
        body: PageView(
          
          onPageChanged: onPageChanged,
          children: [
            FeedScreen(),
            SearchScreen(),
            ProfileScreen()
          ],
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
        )
        
      );
    
  }
}

