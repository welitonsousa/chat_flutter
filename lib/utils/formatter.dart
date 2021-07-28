import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Formatter {
  static String date(String date) {
    final dateTime = DateTime.tryParse(date);

    final formatter = DateFormat('EEE - MMMM \n hh:mm', 'pt');
    final String formatted = formatter.format(dateTime!);

    return formatted;
  }

  static Image base64fromImage(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static Future<String> encodeBase64(File image) async {
    String base64 = base64Encode((await image.readAsBytes()));
    return '$base64';
  }
}
