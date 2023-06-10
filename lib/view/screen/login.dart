import 'package:chat_app/controller/login/login_cubit.dart';
import 'package:chat_app/controller/login/login_state.dart';
import 'package:chat_app/sheared/color_manager/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widget/dialog.dart';
import 'otp.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoadingLoginState) {
            showProgress(context);
          }
          if (state is SuccessLoginState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OTPScreen(phoneNumber: phoneController.text,verificationId: (state).verificationID),
              ),
            );
          }
          if (state is ErrorLoginState) {
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
          return Scaffold(
            backgroundColor: ColorManager.appDark,
            body: Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hello, Please Enter Your Phone to Login :",
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.indigo,
                              width: 2.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: ColorManager.mainColor,
                              width: 2.5,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14.0),
                          hintText: "Enter Your Phone",
                          hintStyle: const TextStyle(
                            color: ColorManager.gray,
                            fontSize: 15.0,
                          ),
                        ),
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: ColorManager.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your phone number!";
                          } else if (value.length < 11) {
                            return "Too short phone number";
                          } else if (value.length > 11) {
                            return "phone number invalid";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 70.0,
                          height: 40.0,
                          margin: const EdgeInsets.only(right: 15.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                LoginCubit.get(context).phoneAuth(
                                    phoneNumber: "+20${phoneController.text}");
                              }
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
                              "GO",
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
