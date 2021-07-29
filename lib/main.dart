import 'package:festzap_test/controllers/controller_theme.dart';
import 'package:festzap_test/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

final _navigatorKey = new GlobalKey<NavigatorState>();
final navigator = _navigatorKey.currentState!;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = ControllerTheme.instance;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, widget) {
        return MaterialApp(
          title: 'FestZap - Test',
          theme: controller.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
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
      },
    );
  }
}
