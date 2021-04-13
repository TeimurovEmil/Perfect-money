import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_personal_money_app/models/expense_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProviderExp with ChangeNotifier {
  DBProviderExp._();
  static final DBProviderExp db = DBProviderExp._();
  static Database _database;

  String expTrackTable = 'ExpenseTable';
  String columnId = 'id';
  String columnName = 'name';
  String columnExp = 'expense';
  String columnDate = 'date';
  int expSum = 0;

  Future<Database> get databaseExp async {
    if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'ExpenseMoneyTrack.db';
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $expTrackTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName TEXT, $columnExp INTEGER, $columnDate TEXT)',
    );
  }

  Future<List<ExpenseTrack>> getExpMoney() async {
    Database dbExp = await this.databaseExp;
    final List<Map<String, dynamic>> moneyMapList =
        await dbExp.query(expTrackTable);

    final List<ExpenseTrack> expMoneyList = [];

    moneyMapList.forEach((expMoneyMap) {
      expMoneyList.add(ExpenseTrack.fromMap(expMoneyMap));
    });
    calculateTotal();
    return expMoneyList;
  }

  Future<ExpenseTrack> insertMoney(ExpenseTrack expTrack) async {
    Database db = await this.databaseExp;
    expTrack.id = await db.insert(expTrackTable, expTrack.toMap());
    calculateTotal();
    return expTrack;
  }

  Future<int> updateMoney(ExpenseTrack expTrack) async {
    Database db = await this.databaseExp;
    calculateTotal();
    return await db.update(expTrackTable, expTrack.toMap(),
        where: '$columnId = ?', whereArgs: [expTrack.id]);
  }

  Future<int> deleteMoney(int id) async {
    Database db = await this.databaseExp;
    var result = await db.delete(
      expTrackTable,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    calculateTotal();

    return result;
  }

  Future<List> calculateTotal() async {
    Database db = await this.databaseExp;
    List<dynamic> result = await db.rawQuery(
      "SELECT SUM($columnExp) FROM $expTrackTable",
    );
    expSum = result[0]["SUM(expense)"];
    notifyListeners();
    return result;
  }
}
