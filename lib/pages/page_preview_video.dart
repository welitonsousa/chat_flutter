import 'dart:io';

import 'package:festzap_test/configs/colors.dart';
import 'package:festzap_test/controllers/controller_chat.dart';
import 'package:festzap_test/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class PagePreviewVideo extends StatefulWidget {
  @override
  _PagePreviewVideoState createState() => _PagePreviewVideoState();
}

class _PagePreviewVideoState extends State<PagePreviewVideo> {
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
    final args = ModalRoute.of(context)!.settings.arguments as List;
    final _uuid = args[0] as String;
    final _image = args[1] as XFile;

    _controllerVideo = VideoPlayerController.file(File(_image.path));
    _initializeVideoPlayerFuture = _controllerVideo.initialize();
    return SafeArea(
      child: Scaffold(
        bottomSheet: _inputMessage(_uuid, _image.path),
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

  Widget _inputMessage(String uuid, String path) {
    return Container(
      color: AppColors.black,
      child: Row(
        children: [
          Expanded(
            child: CustomInput(
              controller: editMessage,
              label: 'Mensagem',
              maxLines: 3,
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: AppColors.ballomSend,
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () => controller.postImage(
                uuid,
                path,
                message: editMessage.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
