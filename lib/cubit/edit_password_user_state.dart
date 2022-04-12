part of 'edit_password_user_cubit.dart';

abstract class EditPasswordUserState extends Equatable {
  const EditPasswordUserState();

  @override
  List<Object> get props => [];
}

class EditPasswordUserInitial extends EditPasswordUserState {}

class EditPasswordUserLoading extends EditPasswordUserState {}

class EditPasswordUserSuccess extends EditPasswordUserState {}

class EditPasswordUserFailed extends EditPasswordUserState {
  final String error;
  EditPasswordUserFailed(this.error);

  @override
  List<Object> get props => [error];
}
