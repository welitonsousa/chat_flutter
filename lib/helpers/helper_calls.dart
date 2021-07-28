import 'package:festzap_test/configs/dio.dart';

class HelpperCalls {
  static Future<List> getCalls() async {
    try {
      final response = await CustomDio.i.get(
        '/help-desks/?organization=flutter',
      );
      return response.data;
    } catch (e) {
      throw e;
    }
  }
}
