import 'dart:convert';
import 'package:festzap_test/configs/colors.dart';
import 'package:festzap_test/controllers/controller_chat.dart';
import 'package:festzap_test/main.dart';
import 'package:festzap_test/models/model_calls.dart';
import 'package:festzap_test/models/state.dart';
import 'package:festzap_test/pages/page_preview_image_off.dart';
import 'package:festzap_test/routes.dart';
import 'package:festzap_test/utils/formatter.dart';
import 'package:festzap_test/widgets/app_bar.dart';
import 'package:festzap_test/widgets/buttom_sheet.dart';
import 'package:festzap_test/widgets/input.dart';
import 'package:festzap_test/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart' as ap;

// ignore: must_be_immutable
class PageChat extends StatelessWidget {
  String _uuid = "";
  String _name = "";
  String path = "";
  final controller = ControllerChat.instance;
  final recorder = RecordPlatform.instance;
  final editMessage = TextEditingController();
  final audio = AudioPlayer();
  ap.AudioSource? audioSource;

  PageChat() {
    controller.channel = ControllerChat().channel;
    controller.channel.stream.listen((event) {
      Map json = jsonDecode(event);
      controller.addMessage(json);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List;
    _name = args[1] as String;
    _uuid = args[0] as String;

    controller.getHistoric(_uuid);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, widget) {
        return Scaffold(
          appBar: CustomAppBar(label: _name),
          body: _body(),
          bottomSheet: _inputMessage(context),
        );
      },
    );
  }

  Widget _body() {
    if (controller.state == modelState.loading) return CustomLoading();
    return Scrollbar(
      child: ListView.builder(
        controller: controller.scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: controller.messages.length,
        padding: EdgeInsets.only(bottom: 80),
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          double right = message.type! == 'sent' ? 10 : 60;
          double left = message.type! == 'sent' ? 60 : 10;

          return Container(
            margin: EdgeInsets.only(left: left, right: right, top: 5),
            decoration: _decoration(message.type!),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  viewMessage(message),
                  viewPdf(message),
                  viewPhoto(message),
                  viewVideo(message),
                  viewAudio(message),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "${Formatter.date(message.createdAt!)}",
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget viewMessage(LastMessage message) {
    return Visibility(
      visible: message.message != null,
      child: Text(
        "${message.message}",
        style: TextStyle(color: AppColors.black),
      ),
    );
  }

  Widget viewPhoto(LastMessage message) {
    return Visibility(
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network("${message.file}"),
          ),
        ),
        onTap: () {
          navigator.push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  PageViewImageOff(message.file!),
            ),
          );
        },
      ),
      visible: message.file != null &&
          message.file!.substring(message.file!.length - 3) != "pdf" &&
          message.file!.substring(message.file!.length - 3) != "m4a" &&
          message.file!.substring(message.file!.length - 3) != "mp4",
    );
  }

  Widget viewAudio(LastMessage message) {
    return Visibility(
        child: GestureDetector(
          onTap: () async {
            path = "";
            controller.update();
            await audio.stop();

            path = '${message.uuid}';
            print(message.file!);

            await audio
                .setAudioSource(AudioSource.uri(Uri.parse(message.file!)));
            controller.update();

            await audio.play();
            controller.update();
          },
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: [
                  Visibility(
                    child: GestureDetector(
                      child: Icon(Icons.pause),
                      onTap: () async {
                        await audio.stop();
                        controller.update();
                      },
                    ),
                    visible: audio.playerState.playing && message.uuid == path,
                    replacement: Icon(Icons.play_arrow),
                  ),
                  Expanded(
                    child: Container(
                      child: Divider(
                        thickness: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        visible: message.file != null &&
            message.file!.substring(message.file!.length - 3) == "m4a");
  }

  Widget viewPdf(LastMessage message) {
    return Visibility(
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf),
              Container(width: 20),
              Expanded(
                child: Text(
                  "${message.file?.replaceAll('https://test-chat.blubots.com/media/uploads/', '')}",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          launch(message.file!);
        },
      ),
      visible: message.file != null &&
          message.file!.substring(message.file!.length - 3) == "pdf",
    );
  }

  Widget viewVideo(LastMessage message) {
    return Visibility(
      child: GestureDetector(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Icon(Icons.video_collection_outlined),
              Container(width: 20),
              Expanded(
                child: Text(
                  "${message.file?.replaceAll('https://test-chat.blubots.com/media/uploads/', '')}",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
        onTap: () => navigator.pushNamed(NameRoutes.previewVideoOff,
            arguments: message.file),
      ),
      visible: message.file != null &&
          message.file!.substring(message.file!.length - 3) == "mp4",
    );
  }

  Widget _inputMessage(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomInput(
            controller: editMessage,
            label: controller.recording ? 'Gravando audio...' : 'Mensagem',
            enable: !controller.recording,
            maxLines: 3,
            onChange: (String? value) {
              value = value ?? "";
              if (value.length < 2) {
                controller.update();
              }
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.attach_file),
          onPressed: () => _menuOptions(context),
        ),
        IconButton(
          icon: Visibility(
            child: Icon(Icons.send),
            visible: editMessage.text.isNotEmpty,
            replacement: Visibility(
              child: Icon(Icons.mic),
              visible: !controller.recording,
              replacement: Icon(Icons.audiotrack_sharp, color: Colors.red),
            ),
          ),
          onPressed: () async {
            if (editMessage.text.isNotEmpty) {
              final response =
                  await controller.postMessage(_uuid, editMessage.text);
              if (response) editMessage.clear();
            } else {
              bool result = await recorder.hasPermission();
              if (result) {
                if (!await recorder.isRecording()) {
                  await recorder.start();
                  controller.recording = true;
                } else {
                  controller.recording = false;
                  final path = await recorder.stop();
                  await controller.postImage(_uuid, path!);
                  print('enviar audio');
                }
                controller.update();
              }
            }
          },
        ),
      ],
    );
  }

  void _menuOptions(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration(milliseconds: 500));
    ButtomSheet.showMenuBottomSheet(
      context: context,
      title: 'Compartilhar',
      options: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.add_a_photo_outlined),
                  onPressed: () => controller.openGallery(_uuid),
                ),
                Text("Camera"),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.filter),
                  onPressed: () => controller.openGallery(_uuid,
                      source: ImageSource.gallery),
                ),
                Text("Imagem"),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.video_call_outlined),
                  onPressed: () =>
                      controller.openVideo(_uuid, source: ImageSource.gallery),
                ),
                Text("Video"),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.description_outlined),
                  onPressed: () => controller.openFile(_uuid),
                ),
                Text("Arquivos"),
              ],
            ),
          ],
        ),
      ],
    );
  }

  BoxDecoration _decoration(String status) {
    Color color = AppColors.ballomSend;
    if (status == 'sent') color = AppColors.ballomReceive;
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    );
  }
}
