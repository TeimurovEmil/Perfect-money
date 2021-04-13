import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:my_personal_money_app/models/income_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider with ChangeNotifier {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  String incomeTrackTable = 'IncomeTable';
  String columnId = 'id';
  String columnName = 'name';
  String columnIncome = 'income';
  String columnDate = 'date';
  int incomeSum = 0;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'IncomeMoneyTrack.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $incomeTrackTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT, $columnIncome INTEGER, $columnDate TEXT)',
    );
  }

  Future<List<MoneyTrack>> getMoney() async {
    Database db = await this.database;
    final List<Map<String, dynamic>> moneyMapList =
        await db.query(incomeTrackTable);
    print(moneyMapList);
    final List<MoneyTrack> incomeMoneyList = [];

    moneyMapList.forEach((incomeMoneyMap) {
      incomeMoneyList.add(MoneyTrack.fromMap(incomeMoneyMap));
    });
    calculateTotal();
    return incomeMoneyList;
  }

  Future<MoneyTrack> insertMoney(MoneyTrack moneytrack) async {
    Database db = await this.database;
    moneytrack.id = await db.insert(incomeTrackTable, moneytrack.toMap());
    calculateTotal();
    return moneytrack;
  }

  Future<int> updateMoney(MoneyTrack moneytrack) async {
    Database db = await this.database;
    calculateTotal();
    return await db.update(incomeTrackTable, moneytrack.toMap(),
        where: '$columnId = ?', whereArgs: [moneytrack.id]);
  }

  Future<int> deleteMoney(int id) async {
    Database db = await this.database;
    var result = await db.delete(
      incomeTrackTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    calculateTotal();

    return result;
  }

  Future<List> calculateTotal() async {
    Database db = await this.database;
    List<dynamic> result = await db.rawQuery(
      "SELECT SUM($columnIncome) FROM $incomeTrackTable",
    );
    incomeSum = result[0]["SUM(income)"];
    notifyListeners();
    return result;
  }
}
