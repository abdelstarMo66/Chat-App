import 'package:chat_app/controller/chats/chat_cubit.dart';
import 'package:chat_app/controller/chats/chat_states.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/sheared/color_manager/color.dart';
import 'package:chat_app/sheared/constance/constance.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class ChatDetails extends StatelessWidget {
  ChatDetails({Key? key,required this.id}) : super(key: key);
  final String id;
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit()
        ..getUserData(uId: id)
        ..getAllMessage(receiver: id),
      child: BlocConsumer<ChatCubit, ChatStates>(
        listener: (context, state) {
          if(state is SendMessageSuccessState){
            ChatCubit.get(context).autoScroll();
          }
        },
        builder: (context, state) {
          ChatCubit cubit = ChatCubit.get(context);
          return Scaffold(
            backgroundColor: ColorManager.appDark,
            appBar: AppBar(
              elevation: 3.0,
              backgroundColor: ColorManager.appDark,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ConditionalBuilder(
                    condition: cubit.userData != null,
                    builder: (context) => CircleAvatar(
                      radius: 22.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(cubit.userData!.image),
                    ),
                    fallback: (context) => const CircularProgressIndicator(),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: ConditionalBuilder(
                      condition: cubit.userData != null,
                      builder: (context) => Text(
                        cubit.userData!.name,
                        style: TextStyle(
                          color: ColorManager.white.withOpacity(0.9),
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      fallback: (context) => const SizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            body: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 18.0),
              color: Colors.black12,
              child: Column(
                children: [
                  Expanded(
                    child: ConditionalBuilder(
                      condition: cubit.message.isNotEmpty,
                      builder: (context) => ListView.separated(
                        reverse: true,
                        controller: cubit.scrollController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (cubit.message[index].senderId == Constance.uId) {
                            return buildMyMessage(
                                context, cubit.message[index]);
                          }
                          return buildMessage(context, cubit.message[index]);
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 14.0,
                        ),
                        itemCount: cubit.message.length,
                      ),
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message here...',
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                color: ColorManager.mainColor,
                                width: 1.5,
                              ),
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                            hintStyle: const TextStyle(
                              color: ColorManager.gray,
                              fontSize: 16.0,
                            ),
                          ),
                          style: const TextStyle(color: ColorManager.white),
                          maxLines: null,
                        ),
                      ),
                      FloatingActionButton.small(
                        heroTag: "emoji",
                        focusColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        hoverElevation: 0.0,
                        elevation: 0.0,
                        onPressed: () {},
                        child: const Icon(
                          Icons.emoji_emotions_outlined,
                          color: Colors.white70,
                        ),
                      ),
                      FloatingActionButton.small(
                        heroTag: "image",
                        backgroundColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverElevation: 0.0,
                        elevation: 0.0,
                        onPressed: () {},
                        child: const Icon(
                          Icons.image_outlined,
                          color: Colors.white70,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 35.0,
                        width: 35.0,
                        child: FloatingActionButton(
                          heroTag: "send",
                          onPressed: () {
                            cubit.sendMessage(
                              receiver: id,
                              content: messageController.text,
                            );
                            messageController.clear();
                          },
                          elevation: 7.0,
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 22.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget buildMyMessage(context, MessageModel message) => Align(
    alignment: AlignmentDirectional.topStart,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(15.0),
          topEnd: Radius.circular(15.0),
          topStart: Radius.circular(15.0),
        ),
        color: ColorManager.mainColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );

  Widget buildMessage(context, MessageModel message) => Align(
    alignment: AlignmentDirectional.topEnd,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadiusDirectional.only(
          bottomStart: Radius.circular(15.0),
          topEnd: Radius.circular(15.0),
          topStart: Radius.circular(15.0),
        ),
        color: Colors.grey[300],
      ),
      child: Column(
        children: [
          Text(
            message.content,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );

}
