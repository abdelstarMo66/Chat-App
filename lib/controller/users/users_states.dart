abstract class UsersStates {}

class InitialUsersState extends UsersStates {}

class ChangeAppBarState extends UsersStates {}

class ChangeDarkModeState extends UsersStates {}

class GetUsersLoadingState extends UsersStates {}

class GetUsersSuccessState extends UsersStates {}

class GetUsersErrorState extends UsersStates {
  final String error;

  GetUsersErrorState(this.error);
}

class SignOutLoadingState extends UsersStates {}

class SignOutSuccessState extends UsersStates {}

class SignOutErrorState extends UsersStates {
  final String error;

  SignOutErrorState(this.error);
}
