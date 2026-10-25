import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/photo.dart';

class PhotoLocalService {
  // Dùng chung một instance trong ứng dụng.
  PhotoLocalService._();

  static final PhotoLocalService instance = PhotoLocalService._();

  static const String _databaseName = 'lab5_photos.db';
  static const String _tableName = 'PhoTo';

  // Giữ lại tác vụ mở database để tránh mở nhiều lần cùng lúc.
  Future<Database>? _databaseFuture;

  Future<Database> get database {
    return _databaseFuture ??= _openDatabase();
  }

  Future<Database> _openDatabase() async {
    try {
      final directory = await getDatabasesPath();
      final databasePath = p.join(directory, _databaseName);

      return await openDatabase(
        databasePath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE $_tableName (
              id INTEGER PRIMARY KEY,
              albumId INTEGER NOT NULL,
              title TEXT NOT NULL,
              url TEXT NOT NULL,
              thumbnailUrl TEXT NOT NULL
            )
          ''');
        },
      );
    } catch (_) {
      // Nếu mở thất bại, lần gọi sau có thể thử lại.
      _databaseFuture = null;
      rethrow;
    }
  }

  // Lấy toàn bộ Photo đã quan tâm.
  Future<List<Photo>> getWishlist() async {
    final db = await database;

    final rows = await db.query(
      _tableName,
      orderBy: 'id DESC',
    );

    return rows.map((row) => Photo.fromMap(row)).toList();
  }

  // Lưu Photo vào danh sách quan tâm.
  Future<void> savePhoto(Photo photo) async {
    final db = await database;

    await db.insert(
      _tableName,
      photo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Xóa Photo khỏi danh sách quan tâm.
  Future<void> deletePhoto(int id) async {
    final db = await database;

    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Kiểm tra một Photo có đang được quan tâm không.
  Future<bool> isFavorite(int id) async {
    final db = await database;

    final rows = await db.query(
      _tableName,
      columns: ['id'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return rows.isNotEmpty;
  }
}