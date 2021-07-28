import 'dart:io';

import 'package:festzap_test/configs/colors.dart';
import 'package:festzap_test/controllers/controller_chat.dart';
import 'package:festzap_test/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PagePreviewImage extends StatelessWidget {
  final controller = ControllerChat.instance;
  final editMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List;
    final _uuid = args[0] as String;
    final _image = args[1] as XFile;

    return SafeArea(
      child: Scaffold(
        bottomSheet: _inputMessage(_uuid, _image.path),
        backgroundColor: AppColors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CloseButton(color: AppColors.white),
            Image.file(File(_image.path)),
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
