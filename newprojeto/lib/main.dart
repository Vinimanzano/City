import 'package:flutter/material.dart';
import 'package:newprojeto/screens/bairros_screen.dart';
import 'package:newprojeto/screens/login_screen.dart';
import 'package:newprojeto/screens/navigation_bar_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu Aplicativo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomeScreen(username: 'defaultUser'),
        '/bairros': (context) => BairrosScreen(),
      },
    );
  }
}
