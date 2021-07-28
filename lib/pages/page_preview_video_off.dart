import 'package:festzap_test/configs/colors.dart';
import 'package:festzap_test/controllers/controller_chat.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PagePreviewVideoOff extends StatefulWidget {
  @override
  _PagePreviewVideoOffState createState() => _PagePreviewVideoOffState();
}

class _PagePreviewVideoOffState extends State<PagePreviewVideoOff> {
  final controller = ControllerChat.instance;
  final editMessage = TextEditingController();

  late VideoPlayerController _controllerVideo;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void dispose() {
    _controllerVideo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final link = ModalRoute.of(context)!.settings.arguments as String;

    _controllerVideo = VideoPlayerController.network(link);
    _initializeVideoPlayerFuture = _controllerVideo.initialize();
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CloseButton(color: AppColors.white),
            GestureDetector(
              onTap: () {
                if (_controllerVideo.value.isPlaying) {
                  _controllerVideo.pause();
                } else {
                  _controllerVideo.play();
                }
              },
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    _controllerVideo.play();
                    return AspectRatio(
                      aspectRatio: _controllerVideo.value.aspectRatio,
                      child: VideoPlayer(_controllerVideo),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
