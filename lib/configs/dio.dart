import 'package:dio/dio.dart';
import 'package:festzap_test/configs/env.dart';

final _options = BaseOptions(
  baseUrl: Env.base,
  connectTimeout: Env.timeOut,
);

class CustomDio {
  static final i = Dio(_options);
}
