import 'package:festzap_test/pages/Page_home.dart';
import 'package:festzap_test/pages/page_chat.dart';
import 'package:festzap_test/pages/page_preview_image.dart';
import 'package:festzap_test/pages/page_preview_video.dart';
import 'package:festzap_test/pages/page_preview_video_off.dart';
import 'package:flutter/material.dart';

class NameRoutes {
  static String home = "/home";
  static String chat = "/chat";
  static String preview = "/preview/image";
  static String previewVideo = "/preview/video";
  static String previewVideoOff = "/preview/video/off";
}

class Routes {
  static String initial = NameRoutes.home;

  static Map<String, Widget Function(BuildContext)> routes = {
    NameRoutes.home: (context) => PageHome(),
    NameRoutes.chat: (context) => PageChat(),
    NameRoutes.preview: (context) => PagePreviewImage(),
    NameRoutes.previewVideo: (context) => PagePreviewVideo(),
    NameRoutes.previewVideoOff: (context) => PagePreviewVideoOff(),
  };
}
