import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/models/TweetModel.dart';
import 'package:ui/providers/tweetProvider.dart';
import 'package:ui/providers/userProvider.dart';
import 'package:ui/screen/pageviews/edit_profile_screen.dart';
import 'package:ui/screen/pageviews/search_user.dart';
import 'package:ui/screen/pageviews/writeTweetScreen.dart';
import 'package:ui/utils/universal_variables.dart';
import 'package:ui/widget/feedTweetCard.dart';
import 'package:ui/widget/tweetCard.dart';


class   FeedScreen extends StatefulWidget {

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with AutomaticKeepAliveClientMixin<FeedScreen> {

   RefreshController _refreshController = RefreshController(initialRefresh: false);
   UserProvider _userProvider;
   TweetProvider _tweetProvider;
   bool notLoaded = true;
  String uid;
   bool loading = true;

   

   void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    print("_ON_LOADING");
    _refreshController.loadComplete();
  }

    @override
    void initState() { 
      super.initState();
       SchedulerBinding.instance.addPostFrameCallback((_) async { 
      
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      uid = prefs.getString('_id');
    });
    
   });
    }

  @override
  Widget build(BuildContext context) {

      _userProvider = Provider.of<UserProvider>(context);
    _tweetProvider = Provider.of<TweetProvider>(context);

   SchedulerBinding.instance.addPostFrameCallback((_) async {
    await _userProvider.refreshUserDetails(uid);
    await _userProvider.getUserTweets(uid);
     await _userProvider.fetchAllUsers(uid);
     await _tweetProvider.getTopHashTags();
     await _userProvider.updateFriendsDetails(uid);
     await _userProvider.generateFeedForUser(uid);
     
     

    setState(() {
      notLoaded = false;
    });
    });

    final List<TweetModel> tweetsFeed = _userProvider.getFeedTweets;
    
  
    return  Scaffold(
      backgroundColor: UniversalVariables.blackColor,
         appBar: AppBar(
          leading: IconButton(icon: Icon(FluentSystemIcons.ic_fluent_star_filled , size:24 , color: Colors.white,), onPressed: () {}),
          backgroundColor: UniversalVariables.blackColor,
          title: Text("TestGram" , style: TextStyle(color: Colors.white), ),
          centerTitle: true,
          actions: [
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {})
          ],
         
         
        ),
        floatingActionButton: FabCircularMenu(
          fabSize: 40,
          ringDiameter: MediaQuery.of(context).size.width,
          ringWidth: MediaQuery.of(context).size.width * 0.2,
          fabColor: Colors.green,
          ringColor: Colors.green,
          fabOpenIcon: Icon(Icons.menu , color: Colors.white),
          fabCloseIcon: Icon(Icons.close , color: Colors.white),

          children: <Widget>[
            Container(),
            IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => WriteTweetScreen())), icon: Icon(Icons.send , color: Colors.white)),
            IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfileScreen())) , icon: Icon(Icons.person , color: Colors.white)),
    
        ]),
      body: notLoaded ? Center(child: CircularProgressIndicator(),)  :  SmartRefresher(
          controller: _refreshController,
           enablePullDown: true,
           onRefresh: _onRefresh,
           onLoading: _onLoading,
           
        header: BezierCircleHeader(),
          child: ListView(
             
             children: [
                Container(margin: EdgeInsets.all(10),),
                if(tweetsFeed.length == 0) Center(child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Your Feed Seems Empty \n Follow Some People" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                      TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchUserScreen())),
                       child: Text("Click Here To Search And Follow People" , style: TextStyle(color: Colors.amber),))
                    ],
                  ),
                ) ,)
                
                 else ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
                itemBuilder: (context , i) => FeedTweetCard(tweet: tweetsFeed[i],),
              itemCount: tweetsFeed.length,
               ),
             ],
           ),
        ),

      
    );
  }
   @override
  bool get wantKeepAlive => true;
}