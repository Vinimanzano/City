import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newprojeto/screens/TelaSolicitacaoSenha.dart';
import 'package:newprojeto/screens/registrar.dart';
import 'package:newprojeto/screens/navigation_bar_app.dart';
import 'dart:convert';
import 'package:adaptive_theme/adaptive_theme.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const LoginScreen({required this.onToggleTheme, Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _usuario = '';
  String _senha = '';
  bool _obscureText = true;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_usuario == 'user' && _senha == '123') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login bem-sucedido!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NavigationBarApp(username: _usuario),
          ),
        );
        return;
      }

      final Map<String, dynamic> loginData = {
        'username': _usuario,
        'password': _senha,
      };

      try {
        final response = await http.post(
          Uri.parse('http://192.168.0.105:8080/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(loginData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login bem-sucedido!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationBarApp(username: _usuario),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nome de usuário ou senha incorretos.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro na comunicação com o servidor: $e')),
        );
      }
    }
  }

  void _esqueciSenha() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaSolicitacaoSenha()),
    );
  }

  void _registrar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Registrar(
          onToggleTheme: widget.onToggleTheme,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: Image.network(
                    'https://www.w3schools.com/w3images/avatar2.png',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  cursorColor: textColor,
                  decoration: InputDecoration(
                    labelText: 'Usuário',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: textColor),
                  ),
                  style: TextStyle(color: textColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu usuário';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _usuario = value!;
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
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _senha = value!;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 121, 144, 163),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: _esqueciSenha,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  child: Text('Esqueceu a senha?'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registrar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 121, 144, 163),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final currentThemeMode = AdaptiveTheme.of(context).mode;
          final newThemeMode = currentThemeMode == AdaptiveThemeMode.light
              ? AdaptiveThemeMode.dark
              : AdaptiveThemeMode.light;
          AdaptiveTheme.of(context).setThemeMode(newThemeMode);
        },
        child: Icon(Icons.brightness_6),
        tooltip: 'Alternar Tema',
      ),
    );
  }
}
