import 'package:flutter/material.dart';
import 'login_screen.dart';

class ThankYouScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Obrigado, ajudou muito a nossa cidade. Em breve entraremos em contato.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(onToggleTheme: () {}),
                    ),
                  );
                },
                child: Text('Ir para tela de Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
