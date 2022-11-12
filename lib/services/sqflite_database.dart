import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> CreateDataBase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database =
        await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE ApiTable (id INTEGER PRIMARY KEY, uri STRING, body STRING, response STRING,header STRING,time STRING)');
    });
    return database;
  }

  ///insert data in table
  Future<void> insertData(
    Database database,
    String uri,
    String body,
    String response,
    String header,
    String time,
  ) async {
    String qry =
        "insert into ApiTable(uri, body, response, header, time) values('$uri','$body','$response','$header','$time')";
    var cnt = await database.rawInsert(qry);
    print(cnt);
  }

  /// check data in sqflite database table
  Future rawData(Database database, String uri, String body) async {
    String qry = 'SELECT * FROM ApiTable WHERE uri=? and body=?';
    var cnt = await database.rawQuery(
      qry,
      [uri, body],
    );
    log("_____________> $cnt");
    return cnt;
  }

  ///update data in table
  Future<void> updateData(
    Database database,
    int id,
    String uri,
    String body,
    String response,
    String header,
    String time,
  ) async {
    String qry =
        "update ApiTable set uri = '$uri',body = '$body',response = '$response',header = '$header',time = '$time' where id = '$id'";
    await database.rawUpdate(qry);
  }
}

///

///Insert or Update data in local storage
Future<void> insertUpdateDB({
  required Database database,
  required String uri,
  required String body,
  required String? response,
  required String header,
  required String time,
}) async {
  DatabaseHandler().rawData(database, uri, body).then((value) {
    List val = value;
    if (val.length == 0) {
      log("<==== Data Insert ====>");
      DatabaseHandler()
          .insertData(database, uri, body, response!, header.toString(), time.toString());
    } else {
      log("<==== Data Update ====>");
      DatabaseHandler().updateData(
          database, val.first['id'], uri, body, response!, header.toString(), time.toString());
    }
  });
}
