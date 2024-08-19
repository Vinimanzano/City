import 'package:flutter/material.dart';
import 'package:newprojeto/database/database_helper.dart';
import 'package:newprojeto/screens/os_screen.dart';

class BairrosScreen extends StatefulWidget {
  @override
  _BairrosScreenState createState() => _BairrosScreenState();
}

class _BairrosScreenState extends State<BairrosScreen> {
  late Future<List<Map<String, dynamic>>> _bairrosFuture;

  @override
  void initState() {
    super.initState();

    // Inicializa a lista de bairros
    final bairros = [
      'Centro', 'Área Industrial I', 'Área Industrial II', 'Área Industrial III',
      'Jardim Boa Vista', 'Jardim Cidade Nova', 'Jardim das Paineiras', 'Jardim dos Coqueiros',
      'Jardim dos Ipês', 'Jardim dos Pássaros', 'Jardim dos Sapateiros', 'Jardim Esplanada',
      'Jardim Glória', 'Jardim Haro', 'Jardim Imperial', 'Jardim Planalto', 'Jardim Santa Rosa',
      'Jardim São Bento', 'Jardim São José', 'Jardim São Luís', 'Jardim São Paulo', 'Jardim São Sebastião',
      'Jardim São Vicente', 'Jardim Vila Rica', 'Jardim Vila Nova', 'Jardim Vila São João',
      'Jardim Vila São Luís', 'Jardim Vitória', 'Parque das Flores', 'Parque das Nações',
      'Parque dos Eucaliptos', 'Parque dos Sabiás', 'Parque Santa Gertrudes', 'Parque São João',
      'Recanto das Flores', 'Recanto dos Pássaros', 'Recanto do Sol', 'Vila Barreto',
      'Vila Georgina', 'Vila São João', 'Vila São José', 'Vila São Luís', 'Vila São Paulo',
      'Vila São Pedro', 'Vila São Sebastião', 'Vila São Vicente', 'Vila Tupi', 'Vila União',
      'Vila Vitória', 'Vila Yeda'
    ];

    // Inicializa o DatabaseHelper e popula os bairros
    final dbHelper = DatabaseHelper();
    dbHelper.initializeBairros(bairros);

    // Atualiza a lista de bairros
    _bairrosFuture = dbHelper.getBairros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bairros'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bairrosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar bairros'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum bairro encontrado'));
          } else {
            final bairros = snapshot.data!;
            return ListView.builder(
              itemCount: bairros.length,
              itemBuilder: (context, index) {
                final bairro = bairros[index];
                return ListTile(
                  title: Text(bairro['nome']),
                  onTap: () {
                    // Navega para a tela OsScreen e passa o nome do bairro
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OsScreen(
                          bairro: bairro['nome'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Função principal
void main() => runApp(MaterialApp(home: BairrosScreen()));
