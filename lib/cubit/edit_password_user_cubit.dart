import 'package:airplane/models/user_model.dart';
import 'package:airplane/services/user_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'edit_password_user_state.dart';

class EditPasswordUserCubit extends Cubit<EditPasswordUserState> {
  EditPasswordUserCubit() : super(EditPasswordUserInitial());

  void updatePasswordUser(String newPassword) async {
    try {
      emit(EditPasswordUserLoading());
      await UserService().updatePassword(newPassword).then((value) {
        emit(EditPasswordUserSuccess());
      });
    } catch (e) {
      throw e;
    }
  }
}
