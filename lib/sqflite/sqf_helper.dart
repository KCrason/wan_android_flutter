import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'history_bean.dart';

class SqfHelper {
  static final SqfHelper _instance = SqfHelper.internal();

  SqfHelper.internal();

  factory SqfHelper() => _instance;

  final String tableName = 'SearchHistory';
  final String columnId = 'id';
  final String columnSearchTimer = 'searchTime';
  final String columnSearchWord = 'searchWord';

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      return _db = await initDataBase();
    }
  }

  initDataBase() async {
    String databasePath = await getDatabasesPath();
    String newPath = join(databasePath, 'wan_android.db');
    var dataBase = await openDatabase(newPath, version: 1, onCreate: _onCreate);
    return dataBase;
  }

  void _onCreate(Database dataBase, int version) async {
    await dataBase.execute(
        'create table $tableName(id integer primary key autoincrement,$columnSearchTimer integer,$columnSearchWord text)');
    print('Table is created!');
  }

  //插入一条数据
  Future<int> insertSearchHistory(SearchHistoryBean _searchHistoryBean) async {
    var dbClient = await db;
    var result =
        await dbClient.insert('$tableName', _searchHistoryBean.toMap());
    return result;
  }

  //查询数据

  Future<List> queryAllSearchHistory() async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery('select * from $tableName order by $columnSearchTimer desc');
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('select count(*) from $tableName'));
  }

  Future<SearchHistoryBean> getItem(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery('select * from $tableName where id = $id');
    if (result.length == 0) return null;
    return SearchHistoryBean.fromMap(result.first);
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }


  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
