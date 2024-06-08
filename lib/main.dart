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
        backgroundColor: const Color.fromARGB(226, 13, 75, 75),
        title: const Center(
          child: Text(
            'Campeões League of Legends',
            style: TextStyle(
              color: Color.fromARGB(251, 254, 141, 1),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 215, 238, 238),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('https://wallpapercave.com/wp/wp8709839.jpg'),
            const SizedBox(height: 16), // Adiciona um espaço entre a imagem e o texto
            const Text(
              'Explore e adicione campeões e suas características.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16), // Adiciona um espaço entre o texto e o botão
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
                color: Color.fromARGB(226, 13, 75, 75),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.groups_2,
                      color: Color.fromARGB(251, 254, 141, 1),
                      size: 70,
                    ),
                    Text(
                      'Campeões',
                      style: TextStyle(
                        color: Color.fromARGB(251, 254, 141, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
        backgroundColor: const Color.fromARGB(226, 13, 75, 75),
        title: const Text(
          'Campeões',
          style: TextStyle(
            color: Color.fromARGB(251, 254, 141, 1),
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
        backgroundColor: const Color.fromARGB(226, 13, 75, 75),
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
          color: Color.fromARGB(251, 254, 141, 1),
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
  final TextEditingController _controladorRaca = TextEditingController();
  final TextEditingController _controladorClasse = TextEditingController();
  final TextEditingController _controladorRegiao = TextEditingController();
  final TextEditingController _controladorDano = TextEditingController();
  final TextEditingController _controladorUltimate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(226, 13, 75, 75),
        title: const Text(
          'Novo Campeão',
          style: TextStyle(
            color: Color.fromARGB(251, 254, 141, 1),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controladorNome,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              TextField(
                controller: _controladorRaca,
                decoration: const InputDecoration(
                  labelText: 'Raça',
                ),
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              TextField(
                controller: _controladorClasse,
                decoration: const InputDecoration(
                  labelText: 'Classe',
                ),
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              TextField(
                controller: _controladorRegiao,
                decoration: const InputDecoration(
                  labelText: 'Região',
                ),
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              TextField(
                controller: _controladorDano,
                decoration: const InputDecoration(
                  labelText: 'Dano',
                ),
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              TextField(
                controller: _controladorUltimate,
                decoration: const InputDecoration(
                  labelText: 'Ultimate',
                ),
                style: const TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(226, 13, 75, 75),
                      ),
                    ),
                    onPressed: () {
                      final String nome = _controladorNome.text;
                      final String raca = _controladorRaca.text;
                      final String classe = _controladorClasse.text;
                      final String regiao = _controladorRegiao.text;
                      final String dano = _controladorDano.text;
                      final String ultimate = _controladorUltimate.text;
                      final Campeao novoCampeao = Campeao(0, nome, raca, classe, regiao, dano, ultimate);
                      save(novoCampeao).then((id) {
                        Navigator.pop(context, novoCampeao);
                      });
                    },
                    child: const Text(
                      'Salvar',
                      style: TextStyle(
                        color: Color.fromARGB(251, 254, 141, 1),
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Campeao {
  final int id;
  final String nome;
  final String raca;
  final String classe;
  final String regiao;
  final String dano;
  final String ultimate;
  // adicionar atributos
  Campeao(this.id, this.nome, this.raca,this.classe,this.regiao,this.dano,this.ultimate);

  @override
  String toString() {
    return 'Campeao{id: $id, nome: $nome, raca: $raca, classe: $classe, regiao: $regiao, dano: $dano, ultimate: $ultimate}';
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campeao.raca.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              campeao.classe.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
            // Adicione mais atributos aqui
            Text(
              campeao.regiao.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              campeao.dano.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              campeao.ultimate.toString(),
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}