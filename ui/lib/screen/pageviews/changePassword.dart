import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ui/resources/authMethods.dart';
import 'package:ui/utils/universal_variables.dart';


class ChangePassword extends StatefulWidget {
  
  static const routeName = '/change-password';

  final String uid;

  ChangePassword({this.uid}) ;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
   
    
  
  AuthMethods _authMethods = AuthMethods();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController newConfirmpasswordController = TextEditingController();

  bool changing = false;

   void checkNewPassword() {
     if(passwordController.text.isEmpty || confirmpasswordController.text.isEmpty ||
     newpasswordController.text.isEmpty || newConfirmpasswordController.text.isEmpty){
        Fluttertoast.showToast(
        msg: "All Fields Are Necesarry",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
    passwordController.text = "";
    confirmpasswordController.text = "";
    newpasswordController.text = "";
    newConfirmpasswordController.text = "";

    return;
     }
     
     if(passwordController.text != confirmpasswordController.text){
           Fluttertoast.showToast(
        msg: "Old Passwords Don't match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    ); 

    passwordController.text = "";
    confirmpasswordController.text = "";

    return;
     }
     if(newpasswordController.text != newConfirmpasswordController.text){
           Fluttertoast.showToast(
        msg: "New Passwords Don't match",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    ); 
  newpasswordController.text = "";
    newConfirmpasswordController.text = "";

    return;
     }

     if(newpasswordController.text.length <=8){
            Fluttertoast.showToast(
        msg: "Passwords Length Must Be Greater than 8",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    ); 
   newpasswordController.text = "";
    newConfirmpasswordController.text = "";

    return;
     }

     setState(() {
       changing = true;
     });


  _authMethods.changePassword(passwordController.text , newpasswordController.text, widget.uid).then((bool val) {
    if(val){
      setState(() {
        changing = false;
      });

           Fluttertoast.showToast(
        msg: "Success!!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    ); 

      Navigator.of(context).pop();
    } else{
         Fluttertoast.showToast(
        msg: "Some Error Occured. Try Later",
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
    return Scaffold(
       backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(backgroundColor: UniversalVariables.blackColor,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop(),),
      title: Text("Edit Profile" , style: TextStyle(color: Colors.white),),
      actions: [IconButton(onPressed: () => checkNewPassword(), icon: Icon(Icons.check , color: Colors.blue,))],
      ),

      body: Stack(
        children: [
          if(changing) Center(child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
             CircularProgressIndicator(),
             Text("Changing Password...." , style: TextStyle(color: Colors.white),)
            ],),
          )),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               TextFormField(
                 controller: passwordController ,
                      style: TextStyle(color:Colors.white),
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
                        hintText: "Enter Current Password",
                        hintStyle: TextStyle(color: Colors.white24)
                      ),

              ),
               TextFormField(
                 controller: confirmpasswordController ,
                      style: TextStyle(color:Colors.white),
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
                        hintText: "Enter Current Password Again",
                        hintStyle: TextStyle(color: Colors.white24)
                      ),

              ),
               TextFormField(
                 controller: newpasswordController ,
                      style: TextStyle(color:Colors.white),
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
                        hintText: "Enter New Password",
                        hintStyle: TextStyle(color: Colors.white24)
                      ),

              ),
               TextFormField(
                 controller: newConfirmpasswordController ,
                      style: TextStyle(color:Colors.white),
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
                        hintText: "Enter New Password Again",
                        hintStyle: TextStyle(color: Colors.white24)
                      ),

              ),
            ],
          ),
        ],
      ),
    );
  }
}

