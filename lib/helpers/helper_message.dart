import 'package:dio/dio.dart';
import 'package:festzap_test/configs/dio.dart';

class HelperMessage {
  static Future<List> getHistoric(String uuid) async {
    try {
      final response = await CustomDio.i.get('/help-desks/$uuid/history/');
      return response.data;
    } catch (e) {
      throw e;
    }
  }

  static Future<void> postNewMessage(String message, String uuid) async {
    try {
      await CustomDio.i.post('/send-message/', data: {
        "message": message,
        "help_desk": uuid,
      });
    } catch (e) {
      throw e;
    }
  }

  static Future<void> sendImage(String uuid, String path,
      {String? message}) async {
    try {
      String fileName = path.split('/').last;

      FormData data = FormData.fromMap({
        "help_desk": uuid,
        "message": message,
        "file": await MultipartFile.fromFile(
          path,
          filename: fileName,
        ),
      });

      await CustomDio.i.post('/send-message/', data: data);
    } catch (e) {
      throw e;
    }
  }
}
