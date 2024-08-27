import 'package:flutter/material.dart';

class TelaRedefinicaoSenha extends StatefulWidget {
  @override
  _TelaRedefinicaoSenhaState createState() => _TelaRedefinicaoSenhaState();
}

class _TelaRedefinicaoSenhaState extends State<TelaRedefinicaoSenha> {
  final _formKey = GlobalKey<FormState>();
  String _codigo = '';
  String _novaSenha = '';
  String _confirmarSenha = '';
  bool _obscureText = true;

  void _definirNovaSenha() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // Aqui você deve implementar a verificação do código com o backend.
      // Para simplicidade, assumimos que a verificação do código é bem-sucedida.
      // Adicione sua lógica de verificação do código e alteração de senha aqui.
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha redefinida com sucesso!')),
      );
      
      // Navegar para a tela de login
      Navigator.pushReplacementNamed(context, '/login'); // Ajuste o nome da rota conforme necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Redefinir Senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Código de Verificação',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o código de verificação';
                    }
                    // Adicione a lógica para validar o código, se necessário.
                    return null;
                  },
                  onSaved: (value) {
                    _codigo = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nova Senha',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua nova senha';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _novaSenha = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _confirmarSenha = value!;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _definirNovaSenha,
                  child: Text('Redefinir Senha'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
