import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/sheared/color_manager/color.dart';
import 'package:flutter/material.dart';

Widget chatItem({
  required Function()? onTap,
  required UserModel model,
}) =>
    GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(model.image),
            radius: 28.0,
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: TextStyle(
                    color: ColorManager.white.withOpacity(0.9),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  "Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla Bla ",
                  style: TextStyle(
                    color: ColorManager.gray2.withOpacity(0.8),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                "10:09 AM",
                style: TextStyle(
                  color: ColorManager.mainColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              CircleAvatar(
                radius: 10.0,
                backgroundColor: ColorManager.mainColor,
                child: Text(
                  "5",
                  style: TextStyle(
                    color: ColorManager.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
