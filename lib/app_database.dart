import 'package:trabalho_2/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> createDatabase() {
  return getDatabasesPath().then(
    (dbPath) {
      final String path = join(
        dbPath,
        'bankapp.db',
      );
      return openDatabase(
        path,
        onCreate: (db, version) {
          db.execute('CREATE TABLE campeaos('
              'id INTEGER PRIMARY KEY,'
              'nome TEXT,'
              'numeroConta INTEGER)');
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
      campeaoMap['numeroConta'] = campeao.numeroConta;
      return db.insert('campeaos', campeaoMap);
    },
  );
}

Future<List<Campeao>> findAll() {
  return createDatabase().then(
    (db) {
      return db.query('campeaos').then(
        (maps) {
          final List<Campeao> campeaos = [];
          for (Map<String, dynamic> map in maps) {
            final Campeao campeao = Campeao(
              map['id'],
              map['nome'],
              map['numeroConta'],
            );
            campeaos.add(campeao);
          }
          return campeaos;
        },
      );
    },
  );
}