import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:ui/resources/authMethods.dart';
import 'package:ui/screen/homeScreen.dart';
import 'package:ui/utils/universal_variables.dart';


class LoginAndRegisterScreen extends StatefulWidget {

  @override
  _LoginAndRegisterScreenState createState() => _LoginAndRegisterScreenState();
}

class _LoginAndRegisterScreenState extends State<LoginAndRegisterScreen> {

  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController confirmpasswordController = new TextEditingController();
 bool isLogin = true;
 bool buttonPressed = false;


  final AuthMethods _authMethods = AuthMethods();

  void switchLogin() {
     setState(() {
            isLogin = !isLogin;
          });
  }

  void tryLogin() {

   setState(() {
        buttonPressed = true;
      });

    if(emailController.text.isEmpty || passwordController.text.isEmpty){
       Fluttertoast.showToast(
        msg: "Fill All Credentials",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    setState(() {
        buttonPressed = false;
      });

    return;
    }
   _authMethods.login(emailController.text, passwordController.text).then((bool val) => {

     setState(() {
        buttonPressed = false;
      }),
      print(val),

      if(val){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()))
      } else {
        Fluttertoast.showToast(
        msg: "Credentials Dont Match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    )
      }


   });
     
  }

  void tryRegistration() {
    
    setState(() {
          buttonPressed = true;
        });

        if(passwordController.text.length <= 8){
              Fluttertoast.showToast(
        msg: "Passwords Length Must Be Greater Than 8",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

     setState(() {
          buttonPressed = false;
        });

        passwordController.text = "";
        confirmpasswordController.text ="";

        return;
        }

    if(passwordController.text != confirmpasswordController.text){
        Fluttertoast.showToast(
        msg: "Passwords Don't Match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

     setState(() {
          buttonPressed = false;
        });
    } else{
      if(emailController.text.isEmpty || passwordController.text.isEmpty || confirmpasswordController.text.isEmpty || 
      nameController.text.isEmpty || usernameController.text.isEmpty 
      ) {
          Fluttertoast.showToast(
        msg: "All Fields Are Necesarry",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

     setState(() {
          buttonPressed = false;
        });
        return;
      }
     
     _authMethods.register(emailController.text, passwordController.text, usernameController.text,
      nameController.text).then((bool val) => {
        setState(() {
          buttonPressed = false;
        }),

         if(val){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()))
      } else {
        Fluttertoast.showToast(
        msg: "Some Error Occured. Try Again Later",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    )
      }
     });


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Center(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [


          !isLogin ? 
           Container(
             margin: EdgeInsets.all(10),
             child: TextFormField(
               controller: nameController,
               decoration: InputDecoration(
 
                           enabledBorder: UnderlineInputBorder(      
    borderSide: BorderSide(color: Colors.white),   
  ),  
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),


                 hintText: "Name",
                 hintStyle: TextStyle(color: Colors.white)
               ),
               style: TextStyle(color: Colors.white) ,
             )) : Container(),
     
     !isLogin ?    Container(
             margin: EdgeInsets.all(10),
             child: TextFormField(
               controller: usernameController,
               decoration: InputDecoration(
 
                           enabledBorder: UnderlineInputBorder(      
    borderSide: BorderSide(color: Colors.white),   
  ),  
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),


                 hintText: "Username",
                 hintStyle: TextStyle(color: Colors.white)
               ),
               style: TextStyle(color: Colors.white) ,
             )) : Container(),


           Container(
             margin: EdgeInsets.all(10),
             child: TextFormField(
               controller: emailController,
               decoration: InputDecoration(
 
                           enabledBorder: UnderlineInputBorder(      
    borderSide: BorderSide(color: Colors.white),   
  ),  
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),


                 hintText: "Email",
                 hintStyle: TextStyle(color: Colors.white)
               ),
               style: TextStyle(color: Colors.white) ,
             )),
           Container(
             margin: EdgeInsets.all(10),
             child: TextFormField(
               obscureText: true,
               controller: passwordController,
               decoration: InputDecoration(
           
                                enabledBorder: UnderlineInputBorder(      
    borderSide: BorderSide(color: Colors.white),   
  ),  
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
     


                 hintText: "Password",
                 hintStyle: TextStyle(color: Colors.white)
               ),
               style: TextStyle(color: Colors.white) ,
             )),

       !isLogin ?  Container(
             margin: EdgeInsets.all(10),
             child: TextFormField(
               obscureText: true,
               controller: confirmpasswordController,
               decoration: InputDecoration(
           
                                enabledBorder: UnderlineInputBorder(      
    borderSide: BorderSide(color: Colors.white),   
  ),  
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  border: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
     


                 hintText: "Confirm Password",
                 hintStyle: TextStyle(color: Colors.white)
               ),
               style: TextStyle(color: Colors.white) ,
             )) : Container(),


          buttonPressed ? CircularProgressIndicator() : Container(
             margin: EdgeInsets.all(10),
             padding: EdgeInsets.symmetric(vertical:5 , horizontal: 20),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               gradient: LinearGradient(begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green, Colors.blue])
             ),
             child: isLogin ? TextButton(onPressed: () => tryLogin(), child:  Text("Login" , style: TextStyle(color: Colors.white),)) : 
             TextButton(onPressed: () => tryRegistration(), child:  Text("Register" , style: TextStyle(color: Colors.white),))),

            SizedBox(height: 10),
             //Text
            isLogin ? Row(mainAxisSize: MainAxisSize.min ,
            children: [
              Text("New User Here?" , style: TextStyle(color: Colors.white)),
              SizedBox(width: 5,),
              TextButton(onPressed: () => switchLogin(), child: Text("Register" , style: TextStyle(color: Colors.blueAccent),))
            ],
            ) : Row(mainAxisSize: MainAxisSize.min ,
            children: [
              Text("Already Have An Account" , style: TextStyle(color: Colors.white),),
              SizedBox(width: 5,),
              TextButton(onPressed: () => switchLogin(), child: Text("Login" , style: TextStyle(color: Colors.blueAccent),))
            ],)
        ],

        ),
      ),
    );
  }
}