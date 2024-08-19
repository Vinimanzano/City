import 'package:flutter/material.dart';
import 'package:newprojeto/screens/bairros_screen.dart';
import '../screens/home_screen.dart';
import '../screens/navigation_bar_app.dart';
import '../screens/home_screen.dart';
import '../screens/thank_you_screen.dart';
import '../screens/os_screen.dart';

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
        '/bairros_screen': (context) => BairrosScreen(),
        '/navigation_bar': (context) => NavigationBarApp(username: 'Usuário'),
      },
    );
  }
}
