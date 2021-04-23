import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/models/userModel.dart';
import 'package:ui/providers/userProvider.dart';
import 'package:ui/resources/storageMethods.dart';
import 'package:ui/screen/pageviews/changePassword.dart';
import 'package:ui/utils/universal_variables.dart';
import 'package:ui/utils/utilities.dart';
import 'package:ui/widget/custom_tile.dart';


class EditProfileScreen extends StatefulWidget {

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  String uid;
  String name;
  String username;
  String bio;
  String photoUrl;
  

  bool notLoaded = true;
  bool uploading = false; 
  bool tweetLoaded = false;

  StorageMethods _storageMethods = StorageMethods();


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

// SchedulerBinding.instance.addPostFrameCallback((_) async {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       name = prefs.getString('name');
//     username = prefs.getString('username');
//     bio = prefs.getString('bio');
//     uid = prefs.getString('_id');
//     photoUrl = prefs.getString('photoUrl');
//     notLoaded = false;
//     });
//  });
//   }
// 
// 
Future<bool> _showUpdateDialog(UserModel user , UserProvider _userProvider) async {
        showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
          content: new JumpingDotsProgressIndicator(
            
                  fontSize: 40.0,
                  color: Colors.black,
                ),
        title: new Text("Updating..."),
      
      
      );
    });

     bool val = await updateDetails(user , context , _userProvider);

     return val;
   
         
    
   

  }


      addMediaModal(BuildContext context , String uid , UserProvider userProvider){
    showModalBottomSheet(context: context,
    elevation: 0,
    backgroundColor: UniversalVariables.blackColor,
     builder: (context) {
      return Column(
        children: <Widget>[
          Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(
                          Icons.close,
                          color: Colors.white
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Upload Media",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Flexible(child: ListView(
                  children: [
                   
                    ModalTile(title: "Upload a Photo From Gallery", subtitle: "Gallery", icon: FontAwesomeIcons.fileImage,
                    onTap: () {
                      pickImage(source: ImageSource.gallery , uid: uid , userProvider: userProvider );
                    },
                    ),
                    ModalTile(title: "Upload a Photo From Camera", subtitle: "Camera", icon: FontAwesomeIcons.cameraRetro,
                    onTap: () {
                      pickImage(source: ImageSource.camera , uid: uid , userProvider: userProvider);
                    },
                    ),
                  ],
                ))
        ],
      );
    });
  }

    pickImage({@required ImageSource source , String uid , UserProvider userProvider}) async {
 File selectedImage = await Utils.pickImage(source);
 
  onChangePhoto(selectedImage , uid , userProvider);
 
  Navigator.of(context).pop();
}

void onChangePhoto (File media , String uid , UserProvider userProvider) async {
  try{
    print("UPLOADING START");
    String url = await _storageMethods.uploadToStorage(media);
    print(url);  
      userProvider.updatePhotoUrl(url, uid);   
  } catch(err){
    print(err);
    return;
  }
}

Future<bool> updateDetails(UserModel user , BuildContext context , UserProvider _userProvider) async {
  String name;
  String username;
  String bio;
  bool isTrue = false;
 
 nameController.text.isEmpty ? name = user.name : name = nameController.text;
 usernameController.text.isEmpty ? username = user.username : username = usernameController.text;
 bioController.text.isEmpty ? bio = user.bio : bio = bioController.text;

 

 await _userProvider.updateDetails(name, username, bio, user.uid).then((bool val) {
    

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
    
       isTrue = true;
    
     } else{
       Navigator.of(context).pop();
       
         Fluttertoast.showToast(
        msg: "Username Already Exits Try Some Other One.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM  ,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
   
  
    

     }
 });

 return isTrue;

  
}

  @override
  Widget build(BuildContext context) {

    final UserProvider _userProvider = Provider.of<UserProvider>(context);
    final UserModel user = _userProvider.getUser;

    setState(() {
      notLoaded = false;
    });
 

    return notLoaded ? Center(child: CircularProgressIndicator(),) :
     Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: AppBar(backgroundColor: UniversalVariables.blackColor,
      leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop(),),
      title: Text("Edit Profile" , style: TextStyle(color: Colors.white),),
      actions: [IconButton(onPressed: () async {
        bool isTrue = false;
        if(nameController.text.isEmpty && usernameController.text.isEmpty && bioController.text.isEmpty){
              Fluttertoast.showToast(
        msg: "All Fields Cannot be Empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    return;
        }
        isTrue = await _showUpdateDialog(user , _userProvider);
       isTrue ? Navigator.of(context).pop() : print("UPDATE FAILED");
      }, icon: Icon(Icons.check , color: Colors.blue,))],
      ),

      body: SafeArea(
        child: Stack(
          children:[ 
         

            Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage("${user.photoUrl}"),
                    ),
                    TextButton(onPressed: () => addMediaModal(context , user.uid , _userProvider), child: Text("Change Profile Picture" , style: TextStyle(color: Colors.blue),))
                  ],
                ),
              ),

              SizedBox(height: 30),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Your Name: ${user.name}" , style: TextStyle(color: Colors.white),),
                  Text("Your Username: ${user.username}" , style: TextStyle(color: Colors.white),),
                  Text("Your Bio: ${user.bio}" , style: TextStyle(color: Colors.white),),
                ],
              ),

               SizedBox(height: 20),

              TextFormField(
                 controller: nameController ,
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
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.white24)
                      ),

              ),

              TextFormField(
                 controller: usernameController ,
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
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.white24)
                      ),

              ),
              TextFormField(
                 controller: bioController ,
                 maxLines: 5,
                 maxLength: 100,
                      style: TextStyle(color:Colors.white),
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
                        hintText: "Bio",
                        hintStyle: TextStyle(color: Colors.white24)
                      ),

              ),

              SizedBox(height: 20,),
              Center(
                child: TextButton(onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChangePassword(uid: user.uid,))), 
                 child: Text("Change Password" , style: TextStyle(color: Colors.blue),)),
              )
            ],
          ),
          
           ]
        ),
      ),
    );
  }
}




class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}