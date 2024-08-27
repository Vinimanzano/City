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
  String _email = '';
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
        'email': _email,
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
    // Obtendo o tema atual
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registrar',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nome de Usuário',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: textColor),
                      ),
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
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: textColor),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um e-mail';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Por favor, insira um e-mail válido';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        setState(() {
                          _email = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: textColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: textColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
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
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Confirme a Senha',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: textColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            color: textColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
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
          ],
        ),
      ),
    );
  }
}
