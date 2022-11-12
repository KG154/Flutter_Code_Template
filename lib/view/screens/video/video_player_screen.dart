import 'dart:math' as math;

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:code_template/Controller/video_player_controller.dart';
import 'package:code_template/Module/FrameWork/Responsive_UI/Sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../utils/colors.dart';

class VideoPlayerScreen extends StatelessWidget {
  const VideoPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Clr.blackColor,
      body: GetBuilder<VideoPlayerGetX>(
        init: VideoPlayerGetX(),
        dispose: (videoC) {
          if (videoC.controller?.videoPlayerController != null) {
            videoC.controller?.videoPlayerController?.dispose();
          }
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
        },
        builder: (videoC) => Center(
          child: videoC.videoPlayerController!.value.isInitialized
              ? AspectRatio(
                  aspectRatio: videoC.videoPlayerController!.value.aspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ///play video
                      VideoPlayer(videoC.videoPlayerController!),
                      Obx(
                        () => videoC.volSetting.value == 1
                            ? Center(
                                child: Text(
                                  "${(videoC.vol.value * 100).toStringAsFixed(0)} %",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Clr.whiteColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (videoC.showControl.value == 1) {
                            videoC.controlHideShow(0);
                          } else {
                            videoC.controlHideShow(1);
                          }
                        },
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                      Obx(() => videoC.showControl.value == 1
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Text(
                                        videoC.videoPlayerController!.value
                                                    .position
                                                    .toString()
                                                    .split(".")[0]
                                                    .toString()
                                                    .split(":")
                                                    .first !=
                                                "0"
                                            ? videoC.videoPlayerController!
                                                .value.position
                                                .toString()
                                                .split(".")[0]
                                                .toString()
                                            : "${videoC.videoPlayerController!.value.position.toString().split(".")[0].toString().split(":")[1]}:${videoC.videoPlayerController!.value.position.toString().split(".")[0].toString().split(":")[2]}",
                                        style: TextStyle(
                                          color: Clr.whiteColor,
                                        ),
                                      ),
                                    ),

                                    ///show progressbar for video
                                    Expanded(
                                      child: ProgressBar(
                                        progress: videoC.videoPlayerController!
                                            .value.position,
                                        total: videoC.videoPlayerController!
                                            .value.duration,
                                        barHeight: 2.0,
                                        baseBarColor: Colors.black45,
                                        thumbRadius: 1.7.w,
                                        timeLabelTextStyle: const TextStyle(
                                          fontSize: 0,
                                        ),
                                        onSeek: (duration) {
                                          videoC.videoPlayerController!
                                              .seekTo(duration);
                                        },
                                        onDragUpdate: (val) {
                                          videoC.updateControl();
                                        },
                                        onDragEnd: () {
                                          Future.delayed(Duration(seconds: 2),
                                              () {
                                            videoC.controlHideShow(0);
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.w),
                                      child: Text(
                                        videoC.videoPlayerController!.value
                                                    .duration
                                                    .toString()
                                                    .split(".")[0]
                                                    .toString()
                                                    .split(":")
                                                    .first !=
                                                "0"
                                            ? videoC.videoPlayerController!
                                                .value.duration
                                                .toString()
                                                .split(".")[0]
                                                .toString()
                                            : "${videoC.videoPlayerController!.value.duration.toString().split(".")[0].toString().split(":")[1]}:${videoC.videoPlayerController!.value.duration.toString().split(".")[0].toString().split(":")[2]}",
                                        style: TextStyle(
                                          color: Clr.whiteColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ///

                                    GestureDetector(
                                      onTap: () {
                                        videoC.hideVolumeBarFun(1);
                                      },
                                      child: Icon(
                                        Icons.volume_up_sharp,
                                        color: Clr.whiteColor,
                                        size: 7.w,
                                      ),
                                    ),

                                    ///
                                    GestureDetector(
                                      onTap: () {
                                        videoC.backward();
                                      },
                                      child: Container(
                                        height: 8.w,
                                        width: 8.w,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Icon(
                                              Icons.replay_sharp,
                                              color: Clr.whiteColor,
                                              size: 8.w,
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 0.6.w),
                                                child: Text(
                                                  "10",
                                                  style: TextStyle(
                                                      color: Clr.whiteColor,
                                                      fontSize: 6.sp),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    ///show video play pause icon & functionality
                                    GestureDetector(
                                      onTap: () {
                                        videoC.playPause();
                                      },
                                      child: Icon(
                                        videoC.videoPlayerController!.value
                                                .isPlaying
                                            ? Icons.pause_circle_outline
                                            : Icons.play_circle_outline,
                                        color: Clr.whiteColor,
                                        size: 10.w,
                                      ),
                                    ),

                                    ///
                                    GestureDetector(
                                      onTap: () {
                                        videoC.forward();
                                      },
                                      child: Container(
                                        height: 8.w,
                                        width: 8.w,
                                        child: Stack(
                                          children: [
                                            Transform(
                                              alignment: Alignment.center,
                                              transform:
                                                  Matrix4.rotationY(math.pi),
                                              child: Icon(
                                                Icons.replay_sharp,
                                                color: Clr.whiteColor,
                                                size: 8.w,
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 0.6.w),
                                                child: Text(
                                                  "10",
                                                  style: TextStyle(
                                                      color: Clr.whiteColor,
                                                      fontSize: 6.sp),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                    ///
                                    GestureDetector(
                                      onTap: () {
                                        print(MediaQuery.of(context)
                                            .orientation
                                            .index);

                                        if (MediaQuery.of(context)
                                                .orientation
                                                .index ==
                                            1) {
                                          SystemChrome.setEnabledSystemUIMode(
                                              SystemUiMode.manual,
                                              overlays: SystemUiOverlay.values);
                                          SystemChrome
                                              .setPreferredOrientations([
                                            DeviceOrientation.portraitUp,
                                          ]);
                                        } else {
                                          SystemChrome
                                              .setPreferredOrientations([
                                            DeviceOrientation.landscapeRight,
                                            DeviceOrientation.landscapeLeft,
                                          ]);
                                        }
                                      },
                                      child: Icon(
                                        Icons.fullscreen,
                                        color: Clr.whiteColor,
                                        size: 7.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Container()),
                      Obx(
                        () => videoC.volSetting.value == 1
                            ? RotatedBox(
                                quarterTurns: 3,
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 3.w),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 45.w,
                                        padding: EdgeInsets.only(left: 5.w),
                                        child: Slider(
                                          value: videoC.vol.value,
                                          onChanged: (val) {
                                            videoC.vol.value = val;
                                            videoC.volumeSet();
                                          },
                                          onChangeEnd: (val) {
                                            Future.delayed(Duration(seconds: 2),
                                                () {
                                              videoC.hideVolumeBarFun(0);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                    ],
                  ),
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
