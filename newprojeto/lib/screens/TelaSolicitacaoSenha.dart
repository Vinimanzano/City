import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'TelaRedefinicaoSenha.dart'; // Certifique-se de que este é o caminho correto

class TelaSolicitacaoSenha extends StatefulWidget {
  @override
  _TelaSolicitacaoSenhaState createState() => _TelaSolicitacaoSenhaState();
}

class _TelaSolicitacaoSenhaState extends State<TelaSolicitacaoSenha> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

  Future<void> _enviarEmailConfirmacao() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final String apiKey = 'mlsn.690178e003ac3a42f3306686b4ac106fc5c839406f62d3b26fc12e206cd3b56d';
      final String emailFrom = 'MS_JVN0we@trial-o65qngkzq8jgwr12.mlsender.net'; // Altere para um e-mail verificado
      final String subject = 'Código de Redefinição de Senha';
      final String body = 'Seu código de recuperação de senha é: 123456';

      final url = Uri.parse('https://api.mailersend.com/v1/email');

      try {
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'from': {
              'email': emailFrom,
              'name': 'ViniManzano',
            },
            'to': [
              {'email': _email}
            ],
            'subject': subject,
            'text': body,
          }),
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 202) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('E-mail enviado para $_email.')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaRedefinicaoSenha()), // Navegar para a nova tela
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha ao enviar o e-mail: ${response.body}')),
          );
        }
      } catch (e) {
        print('Erro: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao tentar enviar o e-mail.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar Redefinição de Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Solicitar Redefinição de Senha',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu e-mail';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                        return 'Por favor, insira um e-mail válido';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _enviarEmailConfirmacao,
                    child: Text('Enviar e-mail'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
