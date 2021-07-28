import 'package:festzap_test/configs/colors.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PageViewImageOff extends StatelessWidget {
  final String link;
  const PageViewImageOff(this.link);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: CloseButton(color: AppColors.white),
      ),
      body: Container(
        child: PhotoView(
          enablePanAlways: true,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          imageProvider: NetworkImage(this.link),
        ),
      ),
    );
  }
}
