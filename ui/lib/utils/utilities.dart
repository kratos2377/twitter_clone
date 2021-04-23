import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
class Utils {
  static String getUsername(String email){
    return "live:${email.split('@')[0]}";
  } 

  static String getInitials(String displayName) {
   List<String> nameSplit =  displayName.split(' ');
   String firstNameInitial = nameSplit[0][0];
   String lastNameInitial = nameSplit[1][0];
   return firstNameInitial + lastNameInitial;
  }

  static Future<File> pickImage(ImageSource source) async {
    print("UTILS HERE");
 
     File selectedImage = File(await ImagePicker().getImage(source: source).then((pickedFile) => pickedFile.path));
    return compressImage(selectedImage);
  }

  static Future<File> compressImage(File imageToCompress) async {
   var uuid = Uuid();
    final tempDir = await getTemporaryDirectory();

    final path = tempDir.path;
    

    String random = uuid.v4();

    Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    Im.copyResize(image , width:500 , height:500);

    return new File('$path/img_$random.jpg')..writeAsBytesSync(Im.encodeJpg(image , quality:85));
  }

  // static int stateToNum(UserState userState) {
  //   switch (userState) {
  //     case UserState.Offline:
  //       return 0;

  //     case UserState.Online:
  //       return 1;

  //     default:
  //       return 2;
  //   }
  // }

  // static UserState numToState(int number) {
  //   switch (number) {
  //     case 0:
  //       return UserState.Offline;

  //     case 1:
  //       return UserState.Online;

  //     default:
  //       return UserState.Waiting;
  //   }
  // }

  // static String formatDateString(String dateString) {
  //   DateTime dateTime = DateTime.parse(dateString);
  //   var formatter = DateFormat('dd/MM/yy');
  //   return formatter.format(dateTime);
  // }
}