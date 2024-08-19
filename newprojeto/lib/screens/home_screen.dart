import 'package:flutter/material.dart';
import 'bairros_screen.dart';
import 'navigation_bar_app.dart';
import 'home_screen.dart';
import 'thank_you_screen.dart';
import 'os_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu Aplicativo',
      initialRoute: '/home_screen',
      routes: {
        '/home_screen': (context) => MyApp(),
        '/thank_you': (context) => ThankYouScreen(),
        '/os_screen': (context) => OsScreen(bairro: 'Exemplo'),
      },
    );
  }
}
