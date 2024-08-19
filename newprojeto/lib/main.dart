import 'package:flutter/material.dart';
import './screens/bairros_screen.dart';
import './screens/navigation_bar_app.dart';
import './screens/home_screen.dart';
import './screens/thank_you_screen.dart';
import './screens/os_screen.dart';
import './screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu Aplicativo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login_screen',
      routes: {
        '/': (context) => LoginScreen(),
        '/thank_you': (context) => ThankYouScreen(),
        '/os_screen': (context) => OsScreen(bairro: 'Exemplo'),
      },
    );
  }
}
