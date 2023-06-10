import 'package:chat_app/controller/chats/chat_states.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/sheared/constance/constance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(InitialState());

  static ChatCubit get(context) => BlocProvider.of(context);
  UserModel? userData;
  List<MessageModel> myMessage = [];
  List<MessageModel> hisMessage = [];
  List<MessageModel> message = [];
  ScrollController scrollController = ScrollController();

  @override
  Future<void> close() async {
    //cancel streams
    super.close();
  }

  void autoScroll() {
    scrollController.animateTo(0,
        duration: const Duration(microseconds: 100), curve: Curves.easeInOut);
    emit(AutoScrollChatListState());
  }

  Future<void> getUserData({required String uId}) async {
    emit(GetSelectedUserLoadingState());

    FirebaseFirestore.instance.collection("users").get().then((value) {
      value.docs.forEach((element) {
        if (element["uId"] == uId) {
          userData = UserModel.fromJson(element.data());
        }
      });
      emit(GetSelectedUserSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(GetSelectedUserErrorState(error.toString()));
    });
  }

  Future<void> sendMessage({
    required String receiver,
    required String content,
  }) async {
    MessageModel modelMessage = MessageModel(
      receiverId: receiver,
      senderId: Constance.uId!,
      content: content,
      dateTime: DateTime.now().toString(),
    );
    debugPrint("Loading");
    emit(SendMessageLoadingState());

    // add to me data
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Constance.uId!)
        .collection("chats")
        .doc(receiver)
        .collection("message")
        .add(modelMessage.toJson())
        .then((value) {
      autoScroll();
      debugPrint("Done for me");
      emit(SendMessageSuccessState());
    }).catchError((error) {
      debugPrint("error");
      debugPrint(error.toString());
      emit(SendMessageErrorState(error.toString()));
    });

    // add to his data
    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiver)
        .collection("chats")
        .doc(Constance.uId!)
        .collection("message")
        .add(modelMessage.toJson())
        .then((value) {
      debugPrint("Done for his");
      emit(SendMessageSuccessState());
    }).catchError((error) {
      debugPrint("error");
      debugPrint(error.toString());
      emit(SendMessageErrorState(error.toString()));
    });
  }

  Future<void> getAllMessage({required String receiver}) async {
    debugPrint("Loading");
    emit(GetSelectedUserLoadingState());

    FirebaseFirestore.instance
        .collection("users")
        .doc(Constance.uId)
        .collection("chats")
        .doc(receiver)
        .collection("message")
        .orderBy("dateTime",descending: true)
        .snapshots()
        .listen((event) {
      myMessage = [];
      hisMessage = [];
      message = [];
      event.docs.forEach((element) {
        message.add(MessageModel.fromJson(element.data()));

        if (element["senderId"] == Constance.uId) {
          myMessage.add(MessageModel.fromJson(element.data()));
        } else {
          hisMessage.add(MessageModel.fromJson(element.data()));
        }
      });
      debugPrint("Done Getting Message");
      emit(GetMessageSuccessState());
    });
  }
}
