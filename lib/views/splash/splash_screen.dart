import 'package:archive/archive_io.dart';
import 'package:bokon_app/models/profile/user_model.dart';
import 'package:bokon_app/services/hive_service.dart';
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
  static const String baseUrl = 'https://bokon.ru/uploads';
  static const String contentPhotoResized = '/content/photos.zip';
  static const String catalogPhotoResized = '/shop/photos.zip';

  final Dio dio = Dio();
  ProfileUserModel? profileUser;

  Future<bool> saveFile(String urlPath, String path) async {
    Directory downloadsDirectory;
    downloadsDirectory = await getApplicationCacheDirectory();
    // print(downloadsDirectory);
    try {
      String newPath = "${downloadsDirectory.path}/uploads/$path";
      downloadsDirectory = Directory(newPath);
      await downloadsDirectory.create(recursive: true);
      // print("newPath : $newPath");
      if (await downloadsDirectory.exists()) {
        File savePath = File("${downloadsDirectory.path}/bokon.zip");
        // print("${downloadsDirectory.path}/bokon.zip");

        try {
          // print("urlPath : " + baseUrl + urlPath);
          // print(savePath.path);
          dio.download(baseUrl + urlPath, savePath.path,
              onReceiveProgress: (downloaded, totlaSize) async {
            if (downloaded / totlaSize == 1) {
              final inputStream = InputFileStream(savePath.path);
              final archive = ZipDecoder().decodeBuffer(inputStream);
              extractArchiveToDisk(archive, newPath);
            }
          });
        } on DioException catch (e) {
          debugPrint(e.message);
          print("DioException");
          File savePath = File("/assets/$urlPath");
          final inputStream = InputFileStream(savePath.path);
          final archive = ZipDecoder().decodeBuffer(inputStream);
          extractArchiveToDisk(archive, newPath);
        }
      }
    } catch (e) {
      debugPrint("Exception: ${e.toString()}");
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
    profileUser = HiveService.getUserData();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), () {
      if (profileUser == null || profileUser!.id <= 0) {
        Get.toNamed('/login');
      } else {
        Get.toNamed('/home');
      }

      // Get.toNamed('/login');
    });

    saveFile(contentPhotoResized, 'content/photos');

    saveFile(catalogPhotoResized, 'shop/photos');
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
