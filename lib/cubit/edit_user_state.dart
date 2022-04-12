part of 'edit_user_cubit.dart';

abstract class EditUserState extends Equatable {
  const EditUserState();

  @override
  List<Object> get props => [];
}

class EditUserInitial extends EditUserState {}

class EditUserLoading extends EditUserState {}

class EditUserSuccess extends EditUserState {
  final UserModel user;
  EditUserSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class EditUserFailed extends EditUserState {
  final String error;
  EditUserFailed(this.error);

  @override
  List<Object> get props => [error];
}
