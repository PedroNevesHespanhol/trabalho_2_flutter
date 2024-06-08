import 'package:trabalho_2/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> createDatabase() {
  return getDatabasesPath().then(
    (dbPath) {
      final String path = join(
        dbPath,
        'lolapp.db',
      );
      return openDatabase(
        path,
        onCreate: (db, version) {
          db.execute('CREATE TABLE campeoes('
              'id INTEGER PRIMARY KEY,'
              'nome TEXT,'
              'raca TEXT,'
              'classe TEXT,'
              'regiao TEXT,'
              'dano TEXT,'
              'ultimate TEXT)');
        },
        version: 1,
        // onDowngrade: onDatabaseDowngradeDelete,
      );
    },
  );
}

Future<int> save(Campeao campeao) {
  return createDatabase().then(
    (db) {
      final Map<String, dynamic> campeaoMap = {};
      // campeaoMap['id'] = campeao.id;
      campeaoMap['nome'] = campeao.nome;
      campeaoMap['raca'] = campeao.raca;
      campeaoMap['classe'] = campeao.classe;
      campeaoMap['regiao'] = campeao.regiao;
      campeaoMap['dano'] = campeao.dano;
      campeaoMap['ultimate'] = campeao.ultimate;
      return db.insert('campeoes', campeaoMap);
    },
  );
}

Future<List<Campeao>> findAll() {
  return createDatabase().then(
    (db) {
      return db.query('campeoes').then(
        (maps) {
          final List<Campeao> campeoes = [];
          for (Map<String, dynamic> map in maps) {
            final Campeao campeao = Campeao(
              map['id'],
              map['nome'],
              map['raca'],
              map['classe'],
              map['regiao'],
              map['dano'],
              map['ultimate']
            );
            campeoes.add(campeao);
          }
          return campeoes;
        },
      );
    },
  );
}