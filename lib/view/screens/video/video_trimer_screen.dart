import 'dart:io';

import 'package:code_template/Controller/video_player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';

import 'package:get/get.dart';
import 'package:video_trimmer/video_trimmer.dart';


class TrimmerView extends StatefulWidget {
  File file;

  TrimmerView({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final VideoCompressorGetX videoPlayController =
      Get.put(VideoCompressorGetX());
  final Trimmer _trimmer = Trimmer();

  VideoData? info;
  final videoInfo = FlutterVideoInfo();
  double? _startValue;

  double? _endValue;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  @override
  void initState() {
    super.initState();
    // data();

    _loadVideo();
  }

  // data() async {
  //   String videoFilePath = widget.file.path;
  //   info = await videoInfo.getVideoInfo(videoFilePath);
  //   print("====>${info?.filesize}");
  //
  //   if(info!.height! >= 720){
  //
  //   }else {
  //     Get.to(()=> Preview(outputPath));
  //   }
  // }
  //
  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });
    String videoFilePath = widget.file.path;
    info = await videoInfo.getVideoInfo(videoFilePath);
    print("====>${info?.filesize}");

    _trimmer.saveTrimmedVideo(
      startValue: _startValue!,
      endValue: _endValue!,
      onSave: (outputPath) async {
        setState(() {
          _progressVisibility = false;
        });
        debugPrint('OUTPUT PATH: $outputPath');
        Get.back();
        // video compess if >720
        // comp();
        videoPlayController.thumbnailFile = null;
        videoPlayController.pickVideo(outputPath);
        // if (info!.height! >= 720) {
        //   videoPlayController.pickVideo(outputPath);
        // } else {
        //   Get.to(() => Preview(outputPath));
        // }

        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) {
        //       // data();
        //       return Preview(outputPath);
        //     }
        //   ),
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Video Trimmer"),
        ),
        body: Builder(
          builder: (context) => Center(
            child: Container(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Visibility(
                    visible: _progressVisibility,
                    child: const LinearProgressIndicator(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _progressVisibility ? null : () => _saveVideo(),
                    child: const Text("SAVE"),
                  ),
                  Expanded(
                    child: VideoViewer(trimmer: _trimmer),
                  ),
                  Center(
                    child: TrimEditor(
                      trimmer: _trimmer,
                      viewerHeight: 50.0,
                      viewerWidth: MediaQuery.of(context).size.width,
                      maxVideoLength: const Duration(seconds: 60),
                      onChangeStart: (value) {
                        _startValue = value;
                      },
                      onChangeEnd: (value) {
                        _endValue = value;
                      },
                      onChangePlaybackState: (value) {
                        setState(() {
                          _isPlaying = value;
                        });
                      },
                    ),
                  ),
                  TextButton(
                    child: _isPlaying
                        ? const Icon(
                            Icons.pause,
                            size: 80.0,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            size: 80.0,
                            color: Colors.white,
                          ),
                    onPressed: () async {
                      bool playbackState = await _trimmer.videPlaybackControl(
                        startValue: _startValue!,
                        endValue: _endValue!,
                      );
                      setState(() {
                        _isPlaying = playbackState;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
