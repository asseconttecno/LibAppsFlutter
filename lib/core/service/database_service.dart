


import 'database_hive.dart';

class DatabaseService {
  final DatabaseHive _service = DatabaseHive();

  Future<List<T>> query<T extends HiveObject>(DBTableName table, {bool Function(T)? where}) async {
    final box = await _getBox(table);
    final values = box.values.cast<T>().toList();
    if (where != null) {
      return values.where(where).toList();
    }
    return values;
  }

  Future<int> insert<T extends HiveObject>(DBTableName table, T values) async {
    final box = await _getBox(table);
    final key = await box.add(values);
    return key;
  }

  Future<bool> insertAll<T extends HiveObject>(DBTableName table, List<T> values) async {
    final box = await _getBox(table);
    final keys = await box.addAll(values);
    return keys.isNotEmpty;
  }

  Future<void> update<T extends HiveObject>(DBTableName table, int key, T values) async {
    final box = await _getBox(table);
    await box.put(key, values);
  }

  Future<void> updateWhere<T extends HiveObject>(DBTableName table, T values, bool Function(T) where) async {
    final box = await _getBox(table);
    final keys = box.values.where((v) {
      return where(v as T);
    }).toList();
    for (dynamic key in keys as List<T>) {
      /*if(T is MarcacaoDB){
        key = key as MarcacaoDB;
        key = key.copyWith(marc: values as MarcacaoDB);
      }*/
      await box.put(key.key, key);
    }
  }

  Future<void> delete(DBTableName table, int key) async {
    final box = await _getBox(table);
    await box.delete(key);
  }

  Future<void> deleteWhere<T extends HiveObject>(DBTableName table, bool Function(T) where) async {
    final box = await _getBox(table);
    final keys = box.keys.where((key) {
      final value = box.get(key) as T;
      return where(value);
    }).toList();
    for (final key in keys) {
      await box.delete(key);
    }
  }

  Future<Box<HiveObject>> _getBox(DBTableName table) async {
    switch (table) {
      case DBTableName.users:
        return await _service.userBox;
      //case DBTableName.conf:
        //return await _service.confBox;
      default:
        throw Exception('Unknown table');
    }
  }
}

