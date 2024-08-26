import 'package:flutter/material.dart';
import 'package:newprojeto/database/database_helper.dart';
import 'package:newprojeto/screens/os_screen.dart';

class BairrosScreen extends StatefulWidget {
  @override
  _BairrosScreenState createState() => _BairrosScreenState();
}

class _BairrosScreenState extends State<BairrosScreen> {
  late Future<List<Map<String, dynamic>>> _bairrosFuture;
  List<Map<String, dynamic>> _bairros = [];
  List<Map<String, dynamic>> _filteredBairros = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bairrosFuture = _initializeBairros();
    _searchController.addListener(_filterBairros);
  }

  Future<List<Map<String, dynamic>>> _initializeBairros() async {
    final dbHelper = DatabaseHelper();

    // Inicializa a lista de bairros apenas se ainda não estiverem no banco
    final existingBairros = await dbHelper.getBairros();

    if (existingBairros.isEmpty) {
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

      await dbHelper.initializeBairros(bairros);
    }

    final bairrosFromDB = await dbHelper.getBairros();

    // Remover bairros duplicados
    final bairrosUnicos = <String, Map<String, dynamic>>{};
    for (var bairro in bairrosFromDB) {
      bairrosUnicos[bairro['nome']] = bairro;
    }

    final bairrosList = bairrosUnicos.values.toList();

    setState(() {
      _bairros = bairrosList;
      _filteredBairros = bairrosList;
    });

    return bairrosList;
  }

  void _filterBairros() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBairros = _bairros
          .where((bairro) =>
              bairro['nome'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _bairrosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar bairros'));
                } else if (_filteredBairros.isEmpty) {
                  return Center(child: Text('Nenhum bairro encontrado'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredBairros.length,
                    itemBuilder: (context, index) {
                      final bairro = _filteredBairros[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OsScreen(bairro: bairro['nome']),
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: BairrosScreen()));
