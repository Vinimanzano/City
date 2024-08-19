import 'package:flutter/material.dart';
import 'package:newprojeto/database/database_helper.dart';
import 'package:newprojeto/screens/os_screen.dart';

class BairrosScreen extends StatefulWidget {
  @override
  _BairrosScreenState createState() => _BairrosScreenState();
}

class _BairrosScreenState extends State<BairrosScreen> {
  late Future<List<Map<String, dynamic>>> _bairrosFuture;
  final ScrollController _scrollController = ScrollController();

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

    final dbHelper = DatabaseHelper();
    dbHelper.initializeBairros(bairros);

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
            return Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: bairros.length,
                itemBuilder: (context, index) {
                  final bairro = bairros[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OsScreen(bairro: bairro['nome']),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            bairro['nome'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

// Função principal
void main() => runApp(MaterialApp(home: BairrosScreen()));
