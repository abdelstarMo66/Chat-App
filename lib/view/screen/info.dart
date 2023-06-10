
import 'package:chat_app/controller/login/login_cubit.dart';
import 'package:chat_app/controller/login/login_state.dart';
import 'package:chat_app/controller/users/users_cubit.dart';
import 'package:chat_app/sheared/color_manager/color.dart';
import 'package:chat_app/view/screen/android_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userNameController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is ProfileImageErrorState) {
            String error = (state).error;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: ColorManager.black,
                duration: const Duration(seconds: 4),
              ),
            );
          }
          if (state is SuccessCreateUserState) {
            UserCubit().getUsers().then((value) {Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const AndroidApp(),
              ),
                  (route) => false,
            );});
          }
          if (state is ErrorCreateUserState) {
            String error = (state).error;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error),
                backgroundColor: ColorManager.black,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            backgroundColor: ColorManager.appDark,
            body: Form(
              key: formKey,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundImage: cubit.profileImage == null
                              ? const NetworkImage(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
                                )
                              : FileImage(cubit.profileImage!) as ImageProvider,
                        ),
                        Positioned(
                          right: -7,
                          bottom: -7,
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              cubit.getProfileImage();
                            },
                            icon: const CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.add,
                                  color: Colors.black, size: 28.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.indigo,
                              width: 2.5,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: ColorManager.mainColor,
                              width: 1.5,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 14.0),
                          hintText: "Enter Your Name",
                          hintStyle: const TextStyle(
                            color: ColorManager.gray,
                            fontSize: 15.0,
                          ),
                        ),
                        style: const TextStyle(color: ColorManager.white),
                        controller: userNameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 80.0,
                          height: 50.0,
                          margin: const EdgeInsets.only(right: 15.0),
                          child: ElevatedButton(
                            onPressed: () {
                              cubit.createUser(
                                name: userNameController.text,
                                image: cubit.profile,
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  ColorManager.mainColor),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.tealAccent),
                              overlayColor: MaterialStateProperty.all<Color>(
                                  Colors.indigo),
                            ),
                            child: const Text(
                              "Enjoy",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
