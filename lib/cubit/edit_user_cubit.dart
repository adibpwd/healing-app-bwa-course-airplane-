import 'dart:io';

import 'package:airplane/services/firebase_storage_service.dart';
import 'package:airplane/services/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:airplane/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_user_state.dart';

class EditUserCubit extends Cubit<EditUserState> {
  EditUserCubit() : super(EditUserInitial());

  Future updateUser(
      {required Map<String, dynamic> user, File? image = null}) async {
    try {
      emit(EditUserLoading());
      String id = user['id'];
      user.remove('id');
      if (image != null) {
        String imageUrl = await FirebaseStorageService().uploadFile(image);
        user['imageUrl'] = imageUrl;
      }
      UserModel userModel = await UserService().update(id, user);
      emit(EditUserSuccess(userModel));
      return userModel;
    } catch (e) {
      EditUserFailed(e.toString());
    }
  }
}
