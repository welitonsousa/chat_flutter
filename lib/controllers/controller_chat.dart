import 'package:festzap_test/controllers/controller_page_home.dart';
import 'package:festzap_test/helpers/helper_message.dart';
import 'package:festzap_test/main.dart';
import 'package:festzap_test/models/model_calls.dart';
import 'package:festzap_test/models/state.dart';
import 'package:festzap_test/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ControllerChat extends ChangeNotifier {
  static final instance = ControllerChat();

  WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('wss://test-chat.blubots.com/ws/chat/flutter/'),
  );

  modelState state = modelState.stoped;
  List<LastMessage> messages = [];
  bool recording = false;

  void update() {
    notifyListeners();
  }

  final scrollController = new ScrollController();
  Future<void> lastMessage({
    int milliseconds = 10,
    double mult = 10,
    double sum = 0,
  }) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    final position = scrollController.position.maxScrollExtent * mult + sum;
    scrollController.jumpTo(position);
  }

  Future<void> getHistoric(String uuid, {bool loading = true}) async {
    try {
      if (loading) state = modelState.loading;
      notifyListeners();
      final response = await HelperMessage.getHistoric(uuid);
      messages.clear();
      response.forEach((element) {
        messages.add(LastMessage.fromJson(element));
      });
      this.messages = this.messages.reversed.toList();
      this.lastMessage(mult: 2);
      state = modelState.success;
    } catch (e) {
      state = modelState.error;
    } finally {
      notifyListeners();
    }
  }

  void addMessage(Map json) {
    if (json['type'] == 'new_message') {
      messages.add(LastMessage.fromJson({
        ...json['data'],
        "file": json['data']['file'] != null
            ? "https://test-chat.blubots.com" + "${json['data']['file']}"
            : null
      }));
      this.lastMessage(mult: 1, sum: 100);
      ControllerPageHome.instance.getCalls(loading: false);
      notifyListeners();
    }
  }

  Future<bool> postMessage(String uuid, String message) async {
    if (message.trim().isNotEmpty) {
      try {
        await HelperMessage.postNewMessage(message, uuid);

        return true;
      } catch (e) {
        state = modelState.error;
      }
    }
    return false;
  }

  Future<void> postImage(String uuid, String path, {String? message}) async {
    try {
      await HelperMessage.sendImage(uuid, path, message: message);
      navigator.popUntil(ModalRoute.withName(NameRoutes.chat));
    } catch (e) {
      state = modelState.error;
    }
  }

  Future openGallery(String uuid,
      {ImageSource source = ImageSource.camera}) async {
    final ImagePicker picker = ImagePicker();

    try {
      final image = await picker.pickImage(source: source);
      if (image != null) {
        navigator.pushNamed(NameRoutes.preview, arguments: [uuid, image]);
      }
    } catch (e) {
      throw e;
    }
  }

  Future openVideo(String uuid,
      {ImageSource source = ImageSource.camera}) async {
    final ImagePicker picker = ImagePicker();

    try {
      final image = await picker.pickVideo(source: source);
      if (image != null) {
        navigator.pushNamed(NameRoutes.previewVideo, arguments: [uuid, image]);
      }
    } catch (e) {
      throw e;
    }
  }

  Future openFile(String uuid) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        this.postImage(uuid, file.path!);
      }
      navigator.pop();
    } catch (e) {
      throw e;
    }
  }
}
