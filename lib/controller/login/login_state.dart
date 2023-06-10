abstract class LoginStates {}

class InitialState extends LoginStates {}

class LoadingLoginState extends LoginStates {}

class SuccessLoginState extends LoginStates {
  final String verificationID;

  SuccessLoginState({required this.verificationID});
}

class ErrorLoginState extends LoginStates {
  final String error;
  ErrorLoginState(this.error);
}

class PhoneOTPVerified extends LoginStates {}

class LoadingCreateUserState extends LoginStates {}

class SuccessCreateUserState extends LoginStates {}

class ErrorCreateUserState extends LoginStates {
  final String error;
  ErrorCreateUserState(this.error);
}

class ProfileImageSuccessState extends LoginStates {}

class ProfileImageErrorState extends LoginStates {
  final String error;

  ProfileImageErrorState(this.error);
}

class UploadProfileImageLoadingState extends LoginStates {}

class UploadProfileImageSuccessState extends LoginStates {}

class UploadProfileImageErrorState extends LoginStates {
  final String error;

  UploadProfileImageErrorState(this.error);
}

