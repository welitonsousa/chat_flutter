import 'package:festzap_test/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

final _navigatorKey = new GlobalKey<NavigatorState>();
final navigator = _navigatorKey.currentState!;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FestZap - Test',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.initial,
      navigatorKey: _navigatorKey,
      routes: Routes.routes,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [const Locale('pt', 'BR')],
    );
  }
}
