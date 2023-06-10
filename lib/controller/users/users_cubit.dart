import 'package:chat_app/controller/users/users_states.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/sheared/constance/constance.dart';
import 'package:chat_app/sheared/local/cache_helper.dart';
import 'package:chat_app/view/screen/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UsersStates> {
  UserCubit() : super((InitialUsersState()));

  static UserCubit get(context) => BlocProvider.of(context);
  bool search = false;
  List<UserModel> allUsers = [];
  List<UserModel> myProfile = [];
  bool stateDarkMode = true;

  void changeAppBar() {
    search = !search;
    emit(ChangeAppBarState());
  }

  void changeDarkMode(val) {
    stateDarkMode = val;
    emit(ChangeDarkModeState());
  }

  Future<void> getUsers() async {
    allUsers = [];
    myProfile = [];
    emit(GetUsersLoadingState());

    FirebaseFirestore.instance.collection("users").snapshots().listen((event) {
      for (var element in event.docs) {
        if (element["uId"] != Constance.uId) {
          allUsers.add(UserModel.fromJson(element.data()));
        } else {
          myProfile.add(UserModel.fromJson(element.data()));
        }
      }
      emit(GetUsersSuccessState());
    });
  }

  Future<void> signOut(context) async {
    emit(SignOutLoadingState());
    await FirebaseAuth.instance.signOut().then((value) {
      close();
      CacheHelper.removeData(key: 'uId').then((value) {
        if (value) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false);
        }
      });
      allUsers=[];
      myProfile=[];
      emit(SignOutSuccessState());
    }).catchError((error) {
      emit(SignOutErrorState(error.toString()));
    });
  }
}
