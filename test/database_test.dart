import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../lib/data/db/database_helper.dart';
import '../lib/data/models/document_model.dart';

void main() {
  group('DatabaseHelper Tests', () {
    late Database database;
    
    setUp(() async {
      // Create a test database in memory
      database = await openDatabase(
        inMemoryDatabasePath,
        onCreate: (db, version) {
          return db.execute('''
            CREATE TABLE documents (
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              pageCount INTEGER NOT NULL,
              mode TEXT NOT NULL,
              filePath TEXT NOT NULL,
              thumbnailPath TEXT,
              sourceType TEXT NOT NULL
            )
          ''');
        },
        version: 1,
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('Insert and retrieve document', () async {
      // Create a test document
      final testDoc = DocumentModel(
        id: 'test-001',
        title: 'Test Document',
        createdAt: DateTime.now(),
        pageCount: 1,
        mode: 'perfectCopy',
        filePath: '/test/path.pdf',
        thumbnailPath: '/test/thumbnail.jpg',
        sourceType: 'camera',
      );

      // Insert the document
      await database.insert(
        'documents',
        testDoc.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Retrieve the document
      final maps = await database.query(
        'documents',
        where: 'id = ?',
        whereArgs: ['test-001'],
      );

      expect(maps.length, 1);
      expect(maps[0]['title'], 'Test Document');
      expect(maps[0]['pageCount'], 1);
      expect(maps[0]['mode'], 'perfectCopy');
    });

    test('Get all documents ordered by creation date', () async {
      // Create test documents
      final doc1 = DocumentModel(
        id: 'doc1',
        title: 'First Document',
        createdAt: DateTime(2024, 1, 1),
        pageCount: 1,
        mode: 'perfectCopy',
        filePath: '/path1.pdf',
        sourceType: 'camera',
      );

      final doc2 = DocumentModel(
        id: 'doc2',
        title: 'Second Document',
        createdAt: DateTime(2024, 1, 2),
        pageCount: 2,
        mode: 'enhancedScan',
        filePath: '/path2.pdf',
        sourceType: 'gallery',
      );

      // Insert documents
      await database.insert('documents', doc1.toMap());
      await database.insert('documents', doc2.toMap());

      // Get all documents
      final maps = await database.query(
        'documents',
        orderBy: 'createdAt DESC',
      );

      expect(maps.length, 2);
      expect(maps[0]['title'], 'Second Document'); // Most recent first
      expect(maps[1]['title'], 'First Document');
    });
  });
}