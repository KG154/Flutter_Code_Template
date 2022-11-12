import 'dart:io';

import 'package:code_template/view/screens/video/video_compressor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../../../Controller/video_player_controller.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:video_compress/video_compress.dart' as vc;
import 'package:light_compressor/light_compressor.dart';

class Preview extends StatefulWidget {
  final String? outputVideoPath;

  const Preview(this.outputVideoPath, {Key? key}) : super(key: key);

  @override
  _PreviewState createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {
  VideoData? info;
  var desFile = "".obs;
  var displayedFile = "".obs;
  var failureMessage = "".obs;
  var filePath = "".obs;
  var isVideoCompressed = false.obs;
  var showProgress = false.obs;
  final LightCompressor lightCompressor = LightCompressor();
  File? thumbnailFile;
  final videoInfo = FlutterVideoInfo();
  VideoPlayerController? _controller;
  final VideoCompressorGetX videoPlayController =
      Get.put(VideoCompressorGetX());
  File? file;

  @override
  void initState() {
    print("=========>123 ${widget.outputVideoPath}");
    _controller = VideoPlayerController.file(File(widget.outputVideoPath!))
      ..initialize().then((_) {
        setState(() {});
        _controller?.play();
      });
    super.initState();
  }

  // comp() async {
  //   String? videoFilePath = widget.outputVideoPath;
  //   info = await videoInfo.getVideoInfo(videoFilePath!);
  //   print("=======>${info?.height}");
  //   desFile.value = await destinationFile;
  //   if (info!.height! >= 720) {
  //     videoPlayController.desFile.value =
  //         await videoPlayController.destinationFile;
  //     final Stopwatch stopwatch = Stopwatch()..start();
  //     final dynamic response = await videoPlayController.lightCompressor
  //         .compressVideo(
  //             path: videoPlayController.filePath.value,
  //             destinationPath: videoPlayController.desFile.value,
  //             videoQuality: VideoQuality.medium,
  //             isMinBitrateCheckEnabled: false,
  //             iosSaveInGallery: false);
  //     stopwatch.stop();
  //
  //     if (response is OnSuccess) {
  //       videoPlayController.desFile.value = response.destinationPath;
  //
  //       videoPlayController.displayedFile.value =
  //           videoPlayController.desFile.value;
  //       videoPlayController.thumbnailFile =
  //           await vc.VideoCompress.getFileThumbnail(
  //               videoPlayController.displayedFile.value);
  //       videoPlayController.isVideoCompressed.value = true;
  //       videoPlayController.showProgress.value = false;
  //       videoPlayController.update();
  //     } else if (response is OnFailure) {
  //       videoPlayController.failureMessage.value = response.message;
  //       videoPlayController.update();
  //     } else if (response is OnCancelled) {
  //       print(response.isCancelled);
  //     }
  //     Get.to(() => videoPlayController.pickVideo());
  //   }
  //   return widget.outputVideoPath!;
  // }

  Future<String> get destinationFile async {
    String directory;
    final String videoName = '${DateTime.now().millisecondsSinceEpoch}.mp4';
    if (Platform.isAndroid) {
      // Handle this part the way you want to save it in any directory you wish.
      final List<Directory>? dir = await path.getExternalStorageDirectories(
          type: path.StorageDirectory.movies);
      directory = dir!.first.path;
      return File('$directory/$videoName').path;
    } else {
      final Directory dir = await path.getLibraryDirectory();
      directory = dir.path;
      return File('$directory/$videoName').path;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Preview"),
      ),
      body: Stack(
        children: [
          _controller != null
              ? Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: _controller!.value.isInitialized
                        ? VideoPlayer(_controller!)
                        : const Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white),
                          ),
                  ),
                )
              : SizedBox(),
          _controller != null
              ? Center(
                  child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: _controller!.value.isInitialized
                        ? VideoPlayer(_controller!)
                        : const Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.white),
                          ),
                  ),
                )
              : SizedBox(),
          Positioned(
            top: 10,
            right: 20,
            child: Container(
              decoration:
                  BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              child: IconButton(
                  onPressed: () async {
                    Get.to(() => VideoCompressorScreen());
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
