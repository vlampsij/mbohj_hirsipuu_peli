import 'dart:async';
import '../tyokalut/pelaajan_pisteet.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


Future<Database> openDB() async {
  final database = await openDatabase(
    join(await getDatabasesPath(), 'pisteet_database.db'),
    onCreate: (db, version) async{
      return db.execute(
        "CREATE TABLE pisteet(id INTEGER PRIMARY KEY AUTOINCREMENT, pistePaivays TEXT, pelaajanPisteet INTEGER)",
      );
    },
    version: 1,
  );
  return database;
}


Future<void> lisaaPisteet(Piste piste, final database) async {
  final Database db = await database;


  await db.insert(
    'pisteet',
    piste.toMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore,
  );
}

Future<List<Piste>> pisteet(final database) async {
  final Database db = await database; //tietokannan referenssi

  final List<Map<String, dynamic>> maps = await db.query('pisteet');

  return List.generate(maps.length, (i) {
    return Piste(
      id: maps[i]['id'],
      pistePaivays: maps[i]['pistePaivays'],
      pelaajanPisteet: maps[i]['pelaajanPisteet'],
    );
  });
}

Future<void> paivitaPisteet(Piste pisteet, final database) async {
  final db = await database;

  await db.update(
    'pisteet',
    pisteet.toMap(),
    where: "id = ?",
    whereArgs: [pisteet.id],
  );
}

Future<void> poistaPiste(int? id, final database) async {
  final db = await database;

  await db.delete(
    'pisteet',
    where: "id = ?",
    whereArgs: [id],
  );
}

void muutaTietokantaa(Piste pisteObject, final database) async {
  await lisaaPisteet(pisteObject, database);
  print(await pisteet(database));
}
