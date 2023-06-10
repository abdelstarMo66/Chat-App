import 'package:chat_app/controller/users/users_cubit.dart';
import 'package:chat_app/controller/users/users_states.dart';
import 'package:chat_app/sheared/color_manager/color.dart';
import 'package:chat_app/view/screen/chat_details_android.dart';
import 'package:chat_app/view/screen/login.dart';
import 'package:chat_app/view/widget/chat_item_android.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../sheared/local/cache_helper.dart';

class AndroidApp extends StatelessWidget {
  const AndroidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final GlobalKey<ScaffoldState> keyScaffold = GlobalKey<ScaffoldState>();

    return BlocProvider(
      create: (context) => UserCubit()..getUsers(),
      child: BlocConsumer<UserCubit, UsersStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = UserCubit.get(context);
          return Scaffold(
            key: keyScaffold,
            drawer: cubit.myProfile.isNotEmpty
                ? Drawer(
                    backgroundColor: ColorManager.appDark,
                    width: size.width / 1.4,
                    child: SafeArea(
                      minimum: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              cubit.myProfile[0].image,
                              height: size.height / 3,
                              width: size.width / 1.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Text(
                            cubit.myProfile[0].name,
                            style: const TextStyle(
                              color: ColorManager.mainColor,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Container(
                            height: 0.5,
                            color: ColorManager.gray,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                bottom: 15.0,
                                right: 0.8,
                              ),
                              child: Row(
                                children: const [
                                  Text(
                                    "Update Profile",
                                    style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.edit,
                                    color: ColorManager.white,
                                    size: 25.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Dark Mode",
                                style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: FlutterSwitch(
                                    borderRadius: 30.0,
                                    width: 50.0,
                                    height: 27.0,
                                    value: cubit.stateDarkMode,
                                    onToggle: (val) {
                                      cubit.changeDarkMode(val);
                                    }),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  cubit.signOut(context);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 30.0,
                                  ),
                                  child: Text(
                                    "Sign Out",
                                    style: TextStyle(
                                      color: ColorManager.white,
                                      fontSize: 22.0,
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
                  )
                : const Drawer(),
            backgroundColor: ColorManager.appDark,
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    color: ColorManager.appDark,
                    child: cubit.search == false
                        ? Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Chats",
                                    style: TextStyle(
                                      color:
                                          ColorManager.white.withOpacity(0.9),
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.changeAppBar();
                                },
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: const Icon(
                                  Icons.search_outlined,
                                  size: 25.0,
                                  color: ColorManager.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  keyScaffold.currentState!.openDrawer();
                                },
                                child: ConditionalBuilder(
                                  condition: cubit.myProfile.isNotEmpty,
                                  builder: (context) => CircleAvatar(
                                    radius: 24.0,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        NetworkImage(cubit.myProfile[0].image),
                                  ),
                                  fallback: (context) =>
                                      const CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: ColorManager.mainColor,
                                          width: 2.5,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(12.0),
                                          bottomLeft: Radius.circular(12.0),
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                        color: ColorManager.mainColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    hintText: "Search",
                                    hintStyle: const TextStyle(
                                      color: ColorManager.gray2,
                                      fontSize: 15.0,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search_outlined,
                                      color: ColorManager.gray,
                                      size: 22.0,
                                    ),
                                  ),
                                  style: const TextStyle(
                                      color: ColorManager.white),
                                  maxLines: 1,
                                  autofocus: false,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.changeAppBar();
                                },
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                icon: const Icon(
                                  Icons.close,
                                  size: 25.0,
                                  color: ColorManager.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                  ConditionalBuilder(
                    condition: cubit.allUsers.isNotEmpty,
                    builder: (context) => Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: ColorManager.blackDark,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => chatItem(
                            model: cubit.allUsers[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetails(
                                      id: cubit.allUsers[index].uId),
                                ),
                              );
                            },
                          ),
                          separatorBuilder: (context, index) => SizedBox(
                            height: size.height / 55,
                          ),
                          itemCount: cubit.allUsers.length,
                        ),
                      ),
                    ),
                    fallback: (context) => const Center(
                      child: Text(
                        "Not User Available",
                        style: TextStyle(
                            color: ColorManager.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
