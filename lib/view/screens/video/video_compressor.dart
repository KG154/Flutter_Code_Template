

import 'package:code_template/Controller/video_player_controller.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../widgets/body.dart';

class VideoCompressorScreen extends StatefulWidget {
  @override
  _VideoCompressorScreenState createState() => _VideoCompressorScreenState();
}

class _VideoCompressorScreenState extends State<VideoCompressorScreen> {
  final VideoCompressorGetX videoPlayController =
      Get.put(VideoCompressorGetX());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Compressor'),
      ),
      body: MySafeArea(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Obx(
                    () => videoPlayController.showProgress.value == false
                        ? Container()
                        : Visibility(
                            visible:
                                !videoPlayController.isVideoCompressed.value,
                            child: StreamBuilder<double>(
                              stream: videoPlayController
                                  .lightCompressor.onProgressUpdated,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.data != null &&
                                    snapshot.data > 0) {
                                  videoPlayController.isTrue = true;
                                  return videoPlayController.isTrue
                                      ? Center(
                                          child: Column(
                                          children: [
                                            CircularProgressIndicator(
                                              backgroundColor: Clr.whiteColor,
                                              color: Clr.buttonClr,
                                              // value: double.parse(videoPlayController.process!),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 2.w),
                                              child: Text("Processing...",
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 16,
                                                      color:Clr.grey1)),
                                            ),
                                          ],
                                        ))
                                      // Column(
                                      //   children: <Widget>[
                                      //     Container(
                                      //       height: 40.w,
                                      //       width: 40.w,
                                      //       child: Stack(
                                      //         fit: StackFit.expand,
                                      //         children: [
                                      //           Center(
                                      //             child: Text(
                                      //               '${snapshot.data.toStringAsFixed(
                                      //                   0)}%',
                                      //               style: const TextStyle(
                                      //                   fontSize: 20),
                                      //             ),
                                      //           ),
                                      //           CircularProgressIndicator(
                                      //             value: snapshot.data / 100,
                                      //           ),
                                      //         ],
                                      //       ),
                                      //     ),
                                      //     IconButton(
                                      //       onPressed: () {
                                      //         videoPlayController.cancel();
                                      //       },
                                      //       icon: Icon(Icons.cancel),
                                      //     )
                                      //   ],
                                      // )
                                      : Container();
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ),
                  ),
                  // Obx(
                  //       () =>
                  //       Column(
                  //         children: [
                  //           // Row(
                  //           //   mainAxisAlignment: MainAxisAlignment.center,
                  //           //   children: [
                  //           //     videoPlayController.filePath.value == ""
                  //           //         ? Container()
                  //           //         : Text(
                  //           //         "BEFORE : ${videoPlayController
                  //           //             .getVideoSize(file: File(
                  //           //             videoPlayController.filePath.value))}"),
                  //           //     videoPlayController.desFile.value != "" &&
                  //           //         videoPlayController
                  //           //             .isVideoCompressed.value ==
                  //           //             true
                  //           //         ? Padding(
                  //           //       padding: EdgeInsets.only(left: 10.w),
                  //           //       child: Text(
                  //           //           "AFTER : ${videoPlayController
                  //           //               .getVideoSize(file: File(
                  //           //               videoPlayController.desFile
                  //           //                   .value))}"),
                  //           //     )
                  //           //         : Container(),
                  //           //   ],
                  //           // ),
                  //           videoPlayController.desFile.value != "" &&
                  //               videoPlayController.desFile.value != null ||
                  //               videoPlayController.isVideoCompressed.value ==
                  //                   true
                  //               ? Column(
                  //             children: [
                  //               IntrinsicHeight(
                  //                 child: GetBuilder<VideoCompressorGetX>(
                  //                   builder: (logic) =>
                  //                   logic.thumbnailFile != null ? Stack(
                  //                     fit: StackFit.expand,
                  //                     children: [
                  //
                  //                       Image.file(
                  //                           logic.thumbnailFile as File,
                  //                           fit: BoxFit.cover),
                  //                       IconButton(
                  //                         onPressed: () {
                  //                           Get.to(() =>
                  //                               VideoPlayerScreen(
                  //                                   videoPlayController
                  //                                       .desFile.value));
                  //                         },
                  //                         icon: Icon(
                  //                           Icons.play_circle_outline,
                  //                           color: Clr.whiteColor,
                  //                           size: 20.w,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ) : SizedBox(),
                  //                 ),
                  //               ),
                  //             ],
                  //           )
                  //               : Container(),
                  //         ],
                  //       ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          videoPlayController.pickVideo(null);
          //     .then((value) {
          // final FilePickerResult? result = await FilePicker.platform.pickFiles(
          //   type: FileType.video,
          // );
          // String? path = result!.files.first.path;
          //   Get.to(()=>TrimmerView(file: File(path!),));
          // });
          // Get.to(()=>TrimmerView(videoPlayController.tempFile!));
        },
        child: Icon(Icons.video_library),
      ),
    );
  }
}
