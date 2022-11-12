import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_template/Controller/home/pagination_controller.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:code_template/services/local_storage.dart';
import 'package:code_template/view/screens/home/profile_screen.dart';
import 'package:code_template/view/screens/home/setting_screen.dart';
import 'package:code_template/view/utils/assets.dart';
import 'package:code_template/view/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/strings.dart';
import '../../widgets/body.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Clr.whiteColor,
      appBar: AppBar(
        toolbarHeight: 20.w,
        backgroundColor: Clr.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          Strings.userList,
          style: TextStyle(color: Clr.blackColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => SettingScreen());
              },
              icon: Icon(
                Icons.settings,
                color: Clr.blackColor,
              )),
        ],
      ),
      body: GetBuilder<PaginationController>(
        init: PaginationController(),
        initState: (userListLogic) {
          /*/// first create db & calling api
          DatabaseHandler().CreateDataBase().then(
            (value) {
              userListLogic.controller!.database = value;
              userListLogic.controller!.userListData();
            },
          );

          /// check internet when app open &
          /// data on  - get data from api &
          /// data off - sqflite db
          internetOnOff(data: () {
            DatabaseHandler().CreateDataBase().then(
              (value) {
                userListLogic.controller!.database = value;
                userListLogic.controller!.userListData();
              },
            );
          });
          userListLogic.controller?.update();*/
        },
        builder: (userListLogic) => MySafeArea(
          child: Obx(
            () => RefreshIndicator(
              onRefresh: () async {
                userListLogic.userListData();
                userListLogic.update();
              },
              child: ListView.builder(
                controller: userListLogic.userListSc,
                itemCount: userListLogic.userList.length + 1,
                itemBuilder: (context, index) {
                  if (index == userListLogic.userList.length) {
                    return Center(
                      child: Container(
                        width: 100.w,
                        height: 10.w,
                        child: Obx(
                          () => Center(
                            child: Opacity(
                              opacity: userListLogic.pageLoader.value == true
                                  ? 1.0
                                  : 00,
                              child: CircularProgressIndicator(
                                  color: Clr.baseColor),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 1.5.w, horizontal: 2.5.w),
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 1.w),
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
                          child: ListTile(
                            onTap: () {
                              box.write(
                                  "user_id",
                                  userListLogic.userList[index].userId
                                      .toString());
                              userListLogic.userId.value = userListLogic
                                  .userList[index].userId
                                  .toString();
                              Get.to(() => ProfileScreen());
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                height: 10.w,
                                width: 10.w,
                                imageUrl:
                                    "${userListLogic.userList[index].profileImage ?? ""}",
                                fit: BoxFit.cover,
                                colorBlendMode: BlendMode.darken,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        Image.asset(Ast.userPlaceHolder),
                                errorWidget: (context, url, error) =>
                                    Image.asset(Ast.userPlaceHolder),
                              ),
                            ),
                            title: Text(
                              "${userListLogic.userList[index].name.toString()}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13.sp),
                            ),
                            subtitle: Text(
                                "${userListLogic.userList[index].email.toString()}"),
                            // subtitle: Text(dateTimeFormat(
                            //     withTime: true,
                            //     userListLogic.userList[index].email
                            //         .toString())),
                          )),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
