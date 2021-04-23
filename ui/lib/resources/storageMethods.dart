import 'dart:io';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:ui/models/userModel.dart';

class StorageMethods {
  Reference _storageReference;

  
  Future<String> uploadToStorage(File media) async {
 
 try {
      _storageReference = FirebaseStorage.instance.ref().child('${DateTime.now().millisecondsSinceEpoch}');

    UploadTask _uploadTask = _storageReference.putFile(media);

    var url = await (await _uploadTask).ref.getDownloadURL();
    print("UPLOADED URL HERE");
    print(url);
    return url;
 } catch (err){
   print(err);
   return null;
 }

  }
 

}