import 'package:archive/archive_io.dart';
// import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final String contentPhotoResized =
      'https://bokon.ru/uploads/content/photos/resized.zip';

  final String catalogPhotoResized =
      'https://bokon.ru/uploads/shop/photos/resized.zip';

  final Dio dio = Dio();

  Future<bool> saveFile(String urlPath, String path) async {
    Directory downloadsDirectory;
    downloadsDirectory = await getApplicationCacheDirectory();
    // print(downloadsDirectory);
    try {
      // print(urlPath);
      String newPath = "${downloadsDirectory.path}/uploads/$path";
      downloadsDirectory = Directory(newPath);
      await downloadsDirectory.create(recursive: true);
      // print("newPath : $newPath");
      if (await downloadsDirectory.exists()) {
        File savePath = File("${downloadsDirectory.path}/bokon.zip");

        dio.download(urlPath, savePath.path,
            onReceiveProgress: (downloaded, totlaSize) async {
          // print(downloaded / totlaSize);
          if (downloaded / totlaSize == 1) {
            // print("OpenFile, ${savePath.path}");

            final inputStream = InputFileStream(savePath.path);
            // print(inputStream.file);

            final archive = ZipDecoder().decodeBuffer(inputStream);
            extractArchiveToDisk(archive, newPath);
            // await OpenFile.open(savePath.path,
            // type: 'application/x-zip-compressed');
          }
        });
      }
    } catch (e) {
      debugPrint("Exception: ${e.toString()}");
    }

    return true;
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), () {
      Get.toNamed('/home');
    });

    saveFile(contentPhotoResized, 'content/photos/resized');
    saveFile(catalogPhotoResized, 'shop/photos/resized');
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            SizedBox(
              height: 3.h,
              child: const LinearProgressIndicator(
                color: Color.fromRGBO(248, 148, 75, 1),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
