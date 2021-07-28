import 'package:festzap_test/helpers/helper_calls.dart';
import 'package:festzap_test/models/model_calls.dart';
import 'package:festzap_test/models/state.dart';
import 'package:flutter/cupertino.dart';

class ControllerPageHome extends ChangeNotifier {
  static final instance = ControllerPageHome();

  modelState state = modelState.stoped;
  List<ModelCalls> listCalls = [];

  Future<void> getCalls({bool loading = true}) async {
    try {
      if (loading) state = modelState.loading;
      notifyListeners();
      final response = await HelpperCalls.getCalls();
      listCalls.clear();
      response.forEach((element) {
        listCalls.add(ModelCalls.fromJson(element));
      });
      state = modelState.success;
    } catch (e) {
      state = modelState.error;
    } finally {
      notifyListeners();
    }
  }
}
