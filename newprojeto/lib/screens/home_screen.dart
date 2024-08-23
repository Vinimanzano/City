import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela Inicial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bem-vindo à Tela Inicial!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/thank_you');
              },
              child: Text('Ir para Tela de Agradecimento'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/os_screen');
              },
              child: Text('Ir para OS Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
