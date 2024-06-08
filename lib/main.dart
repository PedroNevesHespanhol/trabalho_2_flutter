import 'package:flutter/material.dart';
import 'package:trabalho_2/app_database.dart';

void main() {
  runApp(
    const LolApp(),
  );
}

class LolApp extends StatelessWidget {
  const LolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 27, 117, 153),
        title: const Text(
          'Campeões League of Legends',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
                'https://wallpapercave.com/wp/wp8709839.jpg'),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListaCampeoes(),
                  ),
                );
              },
              child: Container(
                height: 140,
                width: 120,
                padding: const EdgeInsets.all(8.0),
                color: Color.fromARGB(255, 27, 117, 153),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(
                      'Campeões',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
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

class ListaCampeoes extends StatefulWidget {
  const ListaCampeoes({super.key});

  @override
  _ListaCampeoesState createState() => _ListaCampeoesState();
}

class _ListaCampeoesState extends State<ListaCampeoes> {
  final List<Campeao> campeoes = [];

  @override
  void initState() {
    super.initState();
    _reloadchamps();
  }

  void _reloadchamps() {
    findAll().then((champs) {
      setState(() {
        campeoes.clear();
        campeoes.addAll(champs);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 27, 117, 153),
        title: const Text(
          'Campeões',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<Campeao>>(
        future: findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Erro ao carregar Campeões'),
            );
          } else if (snapshot.hasData) {
            final List<Campeao> campeoes = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: campeoes.length,
              itemBuilder: (context, index) {
                final Campeao campeao = campeoes[index];
                return _CampeaoItem(campeao);
              },
            );
          } else {
            return const Center(
              child: Text('Nenhum Campeão encontrado'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(255, 27, 117, 153),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormularioCampeoes(),
            ),
          ).then((_) => _reloadchamps());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35.0,
        ),
      ),
    );
  }
}

class FormularioCampeoes extends StatefulWidget {
  const FormularioCampeoes({super.key});

  @override
  _FormularioCampeoesState createState() => _FormularioCampeoesState();
}

class _FormularioCampeoesState extends State<FormularioCampeoes> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorNumeroConta = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 56, 168, 1.0),
        title: const Text(
          'Novo Campeao',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controladorNome,
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
              ),
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            TextField(
              controller: _controladorNumeroConta,
              decoration: const InputDecoration(
                labelText: 'Número da Conta',
              ),
              style: const TextStyle(
                fontSize: 24.0,
              ),
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(0, 56, 168, 1.0),
                    ),
                  ),
                  onPressed: () {
                    final String nome = _controladorNome.text;
                    final int? numeroConta =
                        int.tryParse(_controladorNumeroConta.text);
                    final Campeao novoCampeao = Campeao(0, nome, numeroConta);
                    save(novoCampeao).then((id) {
                      Navigator.pop(context, novoCampeao);
                    });
                  },
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Campeao {
  final int id;
  final String nome;
  final int? numeroConta;
  // adicionar atributos
  Campeao(this.id, this.nome, this.numeroConta);

  @override
  String toString() {
    return 'Campeao{id: $id, nome: $nome, numeroConta: $numeroConta}';
  }
}

class _CampeaoItem extends StatelessWidget {
  final Campeao campeao;

  const _CampeaoItem(this.campeao);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          campeao.nome,
          style: const TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          campeao.numeroConta.toString(),
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}