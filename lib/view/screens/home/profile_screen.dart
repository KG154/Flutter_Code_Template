import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_template/Controller/home/profile_controller.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/services/internet_service.dart';
import 'package:code_template/services/sqflite_database.dart';
import 'package:code_template/view/screens/home/image_view_screen.dart';
import 'package:code_template/view/screens/video/video_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/assets.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../utils/toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Clr.whiteColor,
      appBar: AppBar(
        toolbarHeight: 20.w,
        backgroundColor: Clr.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 3.w),
          child: Text(
            Strings.profile,
            style: TextStyle(color: Clr.blackColor),
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 3.w, top: 3.w),
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Clr.blackColor,
              )),
        ),
      ),
      body: GetBuilder<ProfileDetailController>(
        init: ProfileDetailController(),
        initState: (initLogic) {
          /// first create db & calling api
          DatabaseHandler().CreateDataBase().then(
            (value) {
              initLogic.controller?.database = value;
              initLogic.controller?.profileUserDetail();
              initLogic.controller?.update();
            },
          );

          /// check internet when app open &
          /// data off  - get data from api &
          /// data on - sqflite db
          internetOnOff(data: () {
            DatabaseHandler().CreateDataBase().then(
              (value) {
                initLogic.controller?.database = value;
                initLogic.controller?.profileUserDetail();
                initLogic.controller?.update();
              },
            );
          });

          // initLogic.controller?.profileUserDetail();
        },
        builder: (profileLogic) => RefreshIndicator(
          onRefresh: () async {
            profileLogic.profileUserDetail();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(5.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => ImageViewScreen());
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        height: 30.w,
                        width: 30.w,
                        imageUrl: profileLogic.profileDetailModel?.data?.profileImage
                                .toString()
                                .replaceAll("\\", "") ??
                            "",
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.darken,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                Image.asset(Ast.userPlaceHolder),
                        errorWidget: (context, url, error) =>
                            Image.asset(Ast.userPlaceHolder),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: Clr.whiteColor,
                    borderRadius: BorderRadius.circular(2.w),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1.5),
                        blurRadius: 5,
                        color: Colors.black38,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Email",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                          SizedBox(height: 15),
                          Text("Mobile No.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 15)),
                          SizedBox(height: 15),
                          Text("Created At.",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 15)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " :-  ${profileLogic.profileDetailModel?.data?.name.toString() ?? ""}",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                          SizedBox(height: 15),
                          Text(
                            " :-  ${profileLogic.profileDetailModel?.data?.email.toString() ?? ""}",
                            maxLines: 2,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                          SizedBox(height: 15),
                          Text(
                            " :-  ${profileLogic.profileDetailModel?.data?.phone.toString() ?? ""}",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                          SizedBox(height: 15),
                          Text(
                            " :-  ${profileLogic.profileDetailModel?.data?.createdAt.toString() ?? ""}",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    profileLogic.profileDetailModel?.data?.bioThumb
                                .toString()
                                .replaceAll("\\", "") !=
                            ""
                        ? Get.to(() => VideoPlayerScreen())
                        : MyToast().errorToast(toast: "Video Not found..");
                    ;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: CachedNetworkImage(
                            height: 50.w,
                            width: double.infinity,
                            imageUrl: profileLogic
                                    .profileDetailModel?.data?.bioThumb
                                    .toString()
                                    .replaceAll("\\", "") ??
                                "",
                            fit: BoxFit.cover,
                            colorBlendMode: BlendMode.darken,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    Image.asset(Ast.userPlaceHolder),
                            errorWidget: (context, url, error) =>
                                Image.asset(Ast.userPlaceHolder),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 18.w),
                          child: Center(
                            child: Icon(
                              Icons.play_circle_outline,
                              color: Clr.whiteColor,
                              size: 10.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
