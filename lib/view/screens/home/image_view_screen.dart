import 'package:cached_network_image/cached_network_image.dart';
import 'package:code_template/Controller/home/profile_controller.dart';
import 'package:code_template/View/widgets/body.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MySafeArea(
      child: Scaffold(
        backgroundColor: Clr.whiteColor,
        appBar: AppBar(
          toolbarHeight: 20.w,
          backgroundColor: Clr.whiteColor,
          centerTitle: true,
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.only(top: 3.w),
            child: Text(
              Strings.imageView,
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
        body: SafeArea(
          child: GetBuilder<ProfileDetailController>(
            init: ProfileDetailController(),
            builder: (profileLogic) => Container(
              width: double.infinity,
              height: double.infinity,

              ///for show user image
              child: PhotoView(
                disableGestures: true,
                backgroundDecoration: BoxDecoration(
                  color: Clr.whiteColor,
                ),

                ///show image when internet is on than caching image and than internet is off than show cached image
                imageProvider: CachedNetworkImageProvider(
                  profileLogic.profileDetailModel?.data?.profileImage
                          .toString()
                          .replaceAll("\\", "") ??
                      "",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
