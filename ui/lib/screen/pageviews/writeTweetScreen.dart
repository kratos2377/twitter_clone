import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/providers/userProvider.dart';
import 'package:ui/utils/universal_variables.dart';

class WriteTweetScreen extends StatefulWidget {

  @override
  _WriteTweetScreenState createState() => _WriteTweetScreenState();
}

class _WriteTweetScreenState extends State<WriteTweetScreen> {


  TextEditingController tweet = TextEditingController();
  bool checkPressed = false;
  String uid;
  bool tweeting = false;
  FocusNode tweetNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        SchedulerBinding.instance.addPostFrameCallback((_) async { 
      
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      uid = prefs.getString('_id');
    });
    
   });
  }
  

  void _showDialog() {
    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Cancel Tweet"),
        content: new Text("Are Your Sure You Want To Cancel This Tweet?"),
        actions: [
         new TextButton(onPressed: () {
           tweet.text ="";
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }, child: Text("Yes" , style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold),)),
               new   TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("No" , style: TextStyle(color: Colors.red , fontWeight: FontWeight.bold),))
        ],
      );

    });
  }


  void _showUploadDialog(UserProvider userProvider) async {
        showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
          content: new JumpingDotsProgressIndicator(
            
                  fontSize: 40.0,
                  color: Colors.black,
                ),
        title: new Text("Tweeting..."),
      
      
      );
    });

    await checkTweet(userProvider , context);
   
         
    
   

  }


 Future<void> checkTweet(UserProvider userProvider , BuildContext context) async {

    
  
     await userProvider.writeUserTweet(uid, tweet.text).then((bool val) {
         
         

          if(val){
            Navigator.of(context).pop(); 
            Fluttertoast.showToast(
        msg: "Success!!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

   
    } else{
      Navigator.of(context).pop(); 
      Fluttertoast.showToast(
        msg: "Some Error Occured. Try Again Later",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    }

     });

  }


  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(
        backgroundColor: UniversalVariables.blackColor,
        title: Text("Write Tweet" , style: TextStyle(color: Colors.white),),
      leading: IconButton(onPressed: () => _showDialog(), icon: Icon(Icons.arrow_back)),
      actions: [
        checkPressed ?  Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
          child: JumpingDotsProgressIndicator(
            
                  fontSize: 40.0,
                  color: Colors.white,
                ),
        ) : IconButton(onPressed: () async {
              if(tweet.text.isEmpty){
        Fluttertoast.showToast(
        msg: "Tweet Cannot Be Empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    return;
    }
     
    await _showUploadDialog(userProvider);
     Navigator.of(context).pop();
     await userProvider.addhashName(tweet.text);
        } , icon: Icon(Icons.check , color: Colors.blue  ,))
      ],
      ),

      body: SafeArea(
        child: Stack(
          children: [
          
         

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: new TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: tweet,
                    maxLines: 8,
                    maxLength: 200,
                    decoration: InputDecoration(
                       counterStyle: TextStyle(color: Colors.white),
                                    enabledBorder: UnderlineInputBorder(      
    borderSide: BorderSide(color: Colors.white),   
  ),  
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
                              hintText: "Write Your Tweet Here",
                              hintStyle: TextStyle(color: Colors.white24)
                            
                            ),
                  ),
                ),

                SizedBox(height: 10,),
              ],
            ),
  //  if(tweeting) ... [
  //              BackdropFilter(
  //           filter: ImageFilter.blur(
  //             sigmaX: 5.0,
  //             sigmaY: 5.0,
  //           ),
  //           child: Container(
  //             color: Colors.white.withOpacity(0.6),
  //           ),
  //         ),
  //         Center(
  //           child: Container(
  //               height: MediaQuery.of(context).size.height/2,
  //                   width: MediaQuery.of(context).size.width/1.1,
  //             child:  ClipRRect(
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 child: Image.network(
  //                   "https://i.redd.it/t5d9yfijti5x.png",
  //                   fit: BoxFit.fill,
  //                 ),
  //               ),
              
  //           ),
  //         ),
  //            ],
          ],
        ),
      ) ,
      
    );
  }
}