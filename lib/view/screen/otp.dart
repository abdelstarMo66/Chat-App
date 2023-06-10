import 'package:chat_app/controller/login/login_cubit.dart';
import 'package:chat_app/controller/login/login_state.dart';
import 'package:chat_app/sheared/color_manager/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widget/dialog.dart';
import 'info.dart';

// ignore: must_be_immutable
class OTPScreen extends StatelessWidget {
  late String otpComplete;
  late String phoneNumber;
  late String verificationId;

  OTPScreen(
      {super.key, required this.phoneNumber, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LoadingLoginState) {
              showProgress(context);
            }
            if (state is PhoneOTPVerified) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserInformation(),
                ),
              );
            }
            if (state is ErrorLoginState) {
              String error = (state).error;
              debugPrint(error);
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
              body: Container(
                width: size.width,
                height: size.height,
                margin: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Verify your phone number :",
                      style: TextStyle(
                        color: ColorManager.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      "enter your 6 digit code numbers send to you at $phoneNumber :",
                      style: const TextStyle(
                        color: ColorManager.gray2,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 600.0),
                      child: Column(
                        children: [
                          PinCodeTextField(
                            appContext: context,
                            autoFocus: true,
                            cursorColor: ColorManager.black,
                            keyboardType: TextInputType.number,
                            length: 6,
                            obscureText: false,
                            animationType: AnimationType.scale,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(6),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              borderWidth: 1.0,
                              activeColor: ColorManager.mainColor,
                              inactiveColor: ColorManager.gray2,
                              activeFillColor: ColorManager.mainColor,
                              inactiveFillColor: ColorManager.appDark,
                              selectedColor: ColorManager.mainColor,
                              selectedFillColor: ColorManager.gray,
                            ),
                            animationDuration:
                                const Duration(milliseconds: 300),
                            backgroundColor: ColorManager.appDark,
                            enableActiveFill: true,
                            onCompleted: (code) {
                              otpComplete = code;
                            },
                            onChanged: (value) {},
                          ),
                          const SizedBox(
                            height: 35.0,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                LoginCubit.get(context).submitOTP(
                                    otpCode: otpComplete,
                                    verificationId: verificationId);
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(110.0, 50.0),
                                  backgroundColor: ColorManager.mainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  shadowColor: Colors.tealAccent,
                                  foregroundColor: Colors.indigo),
                              child: const Text(
                                "Verify",
                                style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
