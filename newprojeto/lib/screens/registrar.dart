import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newprojeto/screens/login_screen.dart';

class Registrar extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const Registrar({required this.onToggleTheme, Key? key}) : super(key: key);

  @override
  _RegistrarState createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _telefone = '';
  String _password = '';
  String _confirmPassword = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('As senhas não correspondem')),
        );
        return;
      }

      final Map<String, dynamic> userData = {
        'nome': _username,
        'telefone': _telefone,
        'senha': _password,
      };

      try {
        print('Iniciando requisição de cadastro...');
        final response = await http.post(
          Uri.parse('http://192.168.0.105:8080/usuario'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(userData),
        );

        print('Resposta recebida.');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usuário $_username registrado com sucesso!')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen(onToggleTheme: widget.onToggleTheme)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha ao registrar o usuário. Código: ${response.statusCode} - ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro na comunicação com o servidor: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar'),
        // Remover o IconButton que alterna o tema
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome de Usuário'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome de usuário';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _username = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Número de Celular'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um número de celular';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _telefone = value!;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _password = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Confirme a Senha',
                ),
                obscureText: _obscureConfirmPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme a senha';
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    _confirmPassword = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Registrar'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
