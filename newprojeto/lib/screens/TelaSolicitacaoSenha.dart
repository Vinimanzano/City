import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart'; // Certifique-se de que este import está correto

class TelaSolicitacaoSenha extends StatefulWidget {
  @override
  _TelaSolicitacaoSenhaState createState() => _TelaSolicitacaoSenhaState();
}

class _TelaSolicitacaoSenhaState extends State<TelaSolicitacaoSenha> {
  final _formKey = GlobalKey<FormState>();
  String _telefone = '+551199999999'; // Número de telefone de teste

  Future<void> _enviarWhatsappConfirmacao() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final String accountSid = 'US72fab60e762a2eed71c82ea05ea2997e';
      final String authToken = 'e96c13a9b6faccfb7eea0801a0fb732a';
      final String twilioNumber = 'whatsapp:+19981173690'; // Formato correto
      
      final url = Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'From': twilioNumber,
          'To': 'whatsapp:$_telefone',
          'Body': 'Seu código de recuperação de senha é: 123456 (Teste)',
        },
      );

      // Debugging: Print the status code and response body
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) { // Atualizar para 200 para sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mensagem enviada via WhatsApp para $_telefone.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao enviar mensagem via WhatsApp.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
          crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
          children: [
            Text(
              'Solicitar Redefinição de Senha',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32.0), // Espaçamento extra
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _telefone, // Definindo valor inicial para testes
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu telefone';
                      }
                      if (!RegExp(r'^\+\d{1,3}\d{1,14}$').hasMatch(value)) {
                        return 'Por favor, insira um número de telefone válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _telefone = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _enviarWhatsappConfirmacao,
                    child: Text('Enviar via WhatsApp'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0), // Espaçamento extra
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Navega de volta para a tela anterior
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
