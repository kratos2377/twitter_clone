import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_util/sp_util.dart';
import 'package:ui/loginAndRegister.dart';
import 'package:ui/providers/tweetProvider.dart';
import 'package:ui/providers/userProvider.dart';
import 'package:ui/screen/homeScreen.dart';
import 'package:ui/screen/pageviews/changePassword.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await SpUtil.getInstance();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = prefs.getString('_id');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: TweetProvider()),
      ],
      child: MaterialApp(
        routes: {
          ChangePassword.routeName: (ctx) => ChangePassword()
        },
        title: 'Test002',
        debugShowCheckedModeBanner: false,
      home: CustomSplash(
        imagePath: 'assets/images/logo.png',
        backGroundColor: Colors.black87,
        // backGroundColor: Color(0xfffc6042),
        animationEffect: 'zoom-out' ,
        logoSize: 200,
        home: id == null ? LoginAndRegisterScreen() : HomeScreen(),
        duration: 500,
        type: CustomSplashType.StaticDuration,
      ),
  ),
    )
  );
}

class MainScreen extends StatefulWidget {

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Test002",
      debugShowCheckedModeBanner: false,
      home:  LoginAndRegisterScreen()
      
    );
  }
}