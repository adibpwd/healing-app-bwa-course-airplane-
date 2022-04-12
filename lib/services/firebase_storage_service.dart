import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseStorageService {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    try {
      var upload = await storage.ref(file.path.split("/").last).putFile(file);

      return upload.ref.getDownloadURL();
    } catch (e) {}
    return '';
  }
}
