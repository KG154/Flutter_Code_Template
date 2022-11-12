import 'dart:io';
import 'dart:math';

import 'package:code_template/view/screens/video/video_trimer_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:light_compressor/light_compressor.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:video_compress/video_compress.dart' as vc;
import 'package:video_player/video_player.dart';

import '../view/utils/loader.dart';
import 'home/profile_controller.dart';

class VideoCompressorGetX extends GetxController {
  var desFile = "".obs;
  var displayedFile = "".obs;
  var failureMessage = "".obs;
  var filePath = "".obs;
  var isVideoCompressed = false.obs;
  var showProgress = false.obs;
  final LightCompressor lightCompressor = LightCompressor();
  File? thumbnailFile;
  VideoData? info;
  final videoInfo = FlutterVideoInfo();
  ImagePicker picker = ImagePicker();
  bool isTrue = false;
  String? process = "Proccessing";

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> pickVideo(String? trimPath) async {
    //pick video from gallery
    if (trimPath == null || trimPath == "") {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );

      final PlatformFile? file = result!.files.first;
      filePath.value = file!.path!;

      if (filePath.value != null && filePath.value != "") {
        String videoFilePath = filePath.value;
        info = await videoInfo.getVideoInfo(videoFilePath);
        print("====>${info?.filesize}");
        if (info!.duration! > 60000) {
          Get.to(() => TrimmerView(file: File(filePath.value)));
        } else if (info!.duration! <= 60000 && info!.height! >= 720) {
          failureMessage.value = "";
          isVideoCompressed.value = false;
          showProgress.value = true;
          update();
          Loader.sw();
          desFile.value = await destinationFile;
          thumbnailFile = null;
          final Stopwatch stopwatch = Stopwatch()..start();
          final dynamic response = await lightCompressor.compressVideo(
              path: filePath.value,
              destinationPath: desFile.value,
              videoQuality: VideoQuality.medium,
              isMinBitrateCheckEnabled: false,
              iosSaveInGallery: false);

          stopwatch.stop();

          if (response is OnSuccess) {
            desFile.value = response.destinationPath;

            displayedFile.value = desFile.value;
            thumbnailFile =
                await vc.VideoCompress.getFileThumbnail(displayedFile.value);
            isVideoCompressed.value = true;
            showProgress.value = false;
            Loader.hd();
            update();
          } else if (response is OnFailure) {
            failureMessage.value = response.message;
            update();
          } else if (response is OnCancelled) {
            print(response.isCancelled);
          }
        } else {
          thumbnailFile = null;
          desFile.value = await filePath.value;
          thumbnailFile =
              await vc.VideoCompress.getFileThumbnail(desFile.value);
          update();
        }
        // trim video if filePath.path is more that 1 minut
        // else 1 minut thi nano => get video info => 720 moto => cmpress  use => trimPath = "String";
      } else {
        return;
      }
    } else {
      filePath.value = trimPath;
      // trimPath Info check 720 moti hoy  to compress naitar   return trimPath
    }
    if (trimPath != null && trimPath != "") {
      failureMessage.value = "";
      isVideoCompressed.value = false;
      showProgress.value = true;
      update();
      String videoFilePath = filePath.value;
      info = await videoInfo.getVideoInfo(videoFilePath);

      if (info!.height! >= 720) {
        Loader.sw();
        desFile.value = await destinationFile;
        thumbnailFile = null;
        final Stopwatch stopwatch = Stopwatch()..start();
        final dynamic response = await lightCompressor.compressVideo(
            path: filePath.value,
            destinationPath: desFile.value,
            videoQuality: VideoQuality.medium,
            isMinBitrateCheckEnabled: false,
            iosSaveInGallery: false);

        stopwatch.stop();

        if (response is OnSuccess) {
          desFile.value = response.destinationPath;

          displayedFile.value = desFile.value;
          thumbnailFile =
              await vc.VideoCompress.getFileThumbnail(displayedFile.value);
          isVideoCompressed.value = true;
          showProgress.value = false;
          Loader.hd();
          update();
        } else if (response is OnFailure) {
          failureMessage.value = response.message;
          update();
        } else if (response is OnCancelled) {
          print(response.isCancelled);
        }
      } else {
        thumbnailFile = null;
        desFile.value = await filePath.value;
        thumbnailFile = await vc.VideoCompress.getFileThumbnail(filePath.value);
        // filePath.value = trimPath;
        update();
      }
    }
  }

  ///Trim Video
  /*Future<void> pickVideo(String? trimPath) async {

    if (trimPath == null || trimPath == "") {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
      );

      final PlatformFile? file = result!.files.first;
      filePath.value = file!.path!;

      if (filePath.value != null && filePath.value != "") {
        String videoFilePath = filePath.value;
        info = await videoInfo.getVideoInfo(videoFilePath);
        print("====>${info?.filesize}");
        if (info!.duration! > 60000) {
          Get.to(() => TrimmerView(
                file: File(filePath.value),
              ));
        }

        // trim video if filePath.path is more that 1 minut
        // else 1 minut thi nano => get video info => 720 moto => cmpress  use => trimPath = "String";
      } else {
        return;
      }
    } else {
      filePath.value = trimPath;
      // trimPath Info check 720 moti hoy  to compress naitar   return trimPath
    }
    if (trimPath != null && trimPath == "") {
      failureMessage.value = "";
      isVideoCompressed.value = false;
      showProgress.value = true;
      update();

      desFile.value = await destinationFile;
      final Stopwatch stopwatch = Stopwatch()..start();
      final dynamic response = await lightCompressor.compressVideo(
          path: filePath.value,
          destinationPath: desFile.value,
          videoQuality: VideoQuality.medium,
          isMinBitrateCheckEnabled: false,
          iosSaveInGallery: false);

      stopwatch.stop();

      if (response is OnSuccess) {
        desFile.value = response.destinationPath;

        displayedFile.value = desFile.value;
        thumbnailFile =
            await vc.VideoCompress.getFileThumbnail(displayedFile.value);
        isVideoCompressed.value = true;
        showProgress.value = false;
        update();
      } else if (response is OnFailure) {
        failureMessage.value = response.message;
        update();
      } else if (response is OnCancelled) {
        print(response.isCancelled);
      }
    }
  } */

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

  cancel() {
    failureMessage.value = "";
    desFile.value = "";
    filePath.value = "";
    isVideoCompressed.value = false;
    showProgress.value = false;
    update();
    LightCompressor.cancelCompression();
  }

  String getVideoSize({required File file}) {
    return formatBytes(file.lengthSync(), 2);
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) {
      return '0 B';
    }
    const List<String> suffixes = <String>[
      'B',
      'KB',
      'MB',
      'GB',
      'TB',
      'PB',
      'EB',
      'ZB',
      'YB',
    ];
    final int i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}

class VideoPlayerGetX extends GetxController {
  var vol = 0.5.obs;
  var volSetting = 0.obs;
  var volUpdating = 0.obs;
  var showControl = 1.obs;
  var controlSetup = 0.obs;
  ProfileDetailController profileDetailController =
      Get.put(ProfileDetailController());

  VideoCompressorGetX firstController = Get.find<VideoCompressorGetX>();
  VideoPlayerController? videoPlayerController;

  @override
  void onInit() {
    init();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.onInit();
  }

  // init() {
  //   controller = VideoPlayerController.file(File(firstController.desFile.value))
  //     ..initialize().then((_) {
  //       controller?.play();
  //       controller?.setLooping(true);
  //       controller?.setVolume(0.5);
  //       Future.delayed(Duration(seconds: 2), () {
  //         controlHideShow(0);
  //       });
  //       update();
  //     });
  //   controller?.addListener(() {
  //     update();
  //   });
  //   update();
  // }

  init() async {
    final fileInfo = await checkCacheFor(
        "${profileDetailController.profileDetailModel?.data?.bioVideo.toString()}");
    if (fileInfo == null) {
      videoPlayerController = VideoPlayerController.network(
          "${profileDetailController.profileDetailModel?.data?.bioVideo.toString()}")
        ..initialize().then((_) {
          cachedForUrl(
              "${profileDetailController.profileDetailModel?.data?.bioVideo.toString()}");
          videoPlayerController?.play();
          videoPlayerController?.setLooping(true);
          videoPlayerController?.setVolume(0.5);
          Future.delayed(Duration(seconds: 2), () {
            controlHideShow(0);
          });
          update();
        });
      videoPlayerController?.addListener(() {
        update();
      });
    } else {
      final file = fileInfo.file;
      videoPlayerController = VideoPlayerController.file(file)
        ..initialize().then((_) {
          videoPlayerController?.play();
          videoPlayerController?.setLooping(true);
          videoPlayerController?.setVolume(0.5);
          Future.delayed(Duration(seconds: 2), () {
            controlHideShow(0);
          });
          update();
        });
      videoPlayerController?.addListener(() {
        update();
      });
    }
    /*videoPlayerController = VideoPlayerController.network(
        "${profileDetailController.profileDetailModel?.data?.bioVideo.toString()}")
      ..initialize().then((_) {
        videoPlayerController?.play();
        videoPlayerController?.setLooping(true);
        videoPlayerController?.setVolume(0.5);
        Future.delayed(Duration(seconds: 2), () {
          controlHideShow(0);
        });
        update();
      });
    videoPlayerController?.addListener(() {
      update();
    });*/
    update();
  }

  //: check for cache
  Future<FileInfo?> checkCacheFor(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  //:cached Url Data
  void cachedForUrl(String url) async {
    await DefaultCacheManager().getSingleFile(url).then((value) {
      print('downloaded successfully done for $url');
    });
  }

  //play pause video
  playPause() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController?.pause();
      controlSetup.value = 1;
      controlHideShow(1);
    } else {
      videoPlayerController?.play();
      controlSetup.value = 0;
      Future.delayed(Duration(seconds: 1), () {
        controlHideShow(0);
      });
    }
    update();
  }

  volumeSet() {
    volUpdating.value = 1;
    videoPlayerController?.setVolume(vol.value);
    update();
  }

  hideVolumeBarFun(int val) {
    // 0 hide volume bar
    // 1 show volume bar

    volSetting.value = val;
    volUpdating.value = 0;
    Future.delayed(Duration(seconds: 2), () {
      if (volUpdating.value == 0) {
        volSetting.value = 0;
        update();
      }
    });
    update();
  }

  controlHideShow(int val) {
    showControl.value = val;
    update();
  }

  updateControl() {
    controlSetup.value = 1;
    update();
  }

  forward() {
    Duration position =
        videoPlayerController!.value.position + Duration(seconds: 10);

    if (position <= videoPlayerController!.value.duration) {
      videoPlayerController!.seekTo(position);
      update();
    } else {
      videoPlayerController!.seekTo(videoPlayerController!.value.duration);
      update();
    }
  }

  backward() {
    Duration position =
        videoPlayerController!.value.position - Duration(seconds: 10);
    if (position >= Duration(seconds: 0)) {
      videoPlayerController!.seekTo(position);
      update();
    } else {
      videoPlayerController!.seekTo(Duration(seconds: 0));
      update();
    }
  }
}
