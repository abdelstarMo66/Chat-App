import 'dart:io';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/sheared/local/cache_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(InitialState());
  File? profileImage;
  final imagePicker = ImagePicker();
  late String profile;
  FirebaseAuth auth = FirebaseAuth.instance;
  static LoginCubit get(context) => BlocProvider.of(context);

  @override
  Future<void> close() async {
    //cancel streams
    super.close();
  }

  Future<void> phoneAuth({required String phoneNumber}) async {
    debugPrint("Loading");
    emit(LoadingLoginState());

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException error) {
        debugPrint(error.code.toString());
        emit(ErrorLoginState(error.toString()));
      },
      codeSent: (String verificationId, int? resendToken) {
        emit(SuccessLoginState(verificationID: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> submitOTP(
      {required String otpCode, required String verificationId}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );
    await auth.signInWithCredential(credential).then((value) {
      debugPrint(auth.currentUser!.phoneNumber);
      debugPrint(auth.currentUser!.uid);
      emit(PhoneOTPVerified());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(ErrorLoginState(error.toString()));
    });
  }

  Future<void> getProfileImage() async {
    var pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage = File(pickedImage.path);
      emit(ProfileImageSuccessState());
      uploadProfileImage();
    } else {
      emit(ProfileImageErrorState("No Image Selected"));
    }
  }

  Future<void> uploadProfileImage() async {
    emit(UploadProfileImageLoadingState());

    await FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profile = value;
        emit(UploadProfileImageSuccessState());
      }).catchError((error) {
        debugPrint(error.toString());
        emit(UploadProfileImageErrorState(error.toString()));
      });
    }).catchError((error) {
      debugPrint(error.toString());
      emit(UploadProfileImageErrorState(error.toString()));
    });
  }

  Future<void> createUser({
    required String name,
    String image =
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
  }) async {
    UserModel userModel = UserModel(
      name: name,
      phone: auth.currentUser!.phoneNumber!,
      image: image,
      uId: auth.currentUser!.uid,
    );
    debugPrint("Loading");
    emit(LoadingCreateUserState());

    await FirebaseFirestore.instance
        .collection("users")
        .doc(auth.currentUser!.uid)
        .set(userModel.toJson())
        .then((value) {
      CacheHelper.saveData(key: "uId", value: auth.currentUser!.uid);
      emit(SuccessCreateUserState());
    }).catchError((error) {
      emit(ErrorCreateUserState(error.toString()));
    });
  }
}
