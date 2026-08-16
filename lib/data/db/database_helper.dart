import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/document_model.dart';

class DatabaseHelper {
  static const String _databaseName = 'soft_paper.db';
  static const int _databaseVersion = 1;
  
  static Database? _database;
  
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }
  
  static Future<void> _onCreate(Database db, int version) async {
    // Create documents table
    await db.execute('''
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
    
    // Create pages table
    await db.execute('''
      CREATE TABLE pages (
        id TEXT PRIMARY KEY,
        documentId TEXT NOT NULL,
        orderIndex INTEGER NOT NULL,
        originalImagePath TEXT NOT NULL,
        processedImagePath TEXT NOT NULL,
        ocrText TEXT,
        layoutJson TEXT,
        FOREIGN KEY (documentId) REFERENCES documents (id) ON DELETE CASCADE
      )
    ''');
    
    // Create tool_history table
    await db.execute('''
      CREATE TABLE tool_history (
        id TEXT PRIMARY KEY,
        toolType TEXT NOT NULL,
        inputPath TEXT NOT NULL,
        outputPath TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }
  
  // Document CRUD operations
  static Future<void> insertDocument(DocumentModel document) async {
    final db = await database;
    await db.insert(
      'documents',
      document.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  static Future<DocumentModel?> getDocument(String id) async {
    final db = await database;
    final maps = await db.query(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return DocumentModel.fromMap(maps.first);
    }
    return null;
  }
  
  static Future<List<DocumentModel>> getAllDocuments() async {
    final db = await database;
    final maps = await db.query(
      'documents',
      orderBy: 'createdAt DESC',
    );
    
    return List.generate(maps.length, (i) {
      return DocumentModel.fromMap(maps[i]);
    });
  }
  
  static Future<void> updateDocument(DocumentModel document) async {
    final db = await database;
    await db.update(
      'documents',
      document.toMap(),
      where: 'id = ?',
      whereArgs: [document.id],
    );
  }
  
  static Future<void> deleteDocument(String id) async {
    final db = await database;
    await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Page CRUD operations
  static Future<void> insertPage(PageModel page) async {
    final db = await database;
    await db.insert(
      'pages',
      page.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  static Future<List<PageModel>> getPagesByDocument(String documentId) async {
    final db = await database;
    final maps = await db.query(
      'pages',
      where: 'documentId = ?',
      whereArgs: [documentId],
      orderBy: 'orderIndex ASC',
    );
    
    return List.generate(maps.length, (i) {
      return PageModel.fromMap(maps[i]);
    });
  }
  
  static Future<void> deletePagesByDocument(String documentId) async {
    final db = await database;
    await db.delete(
      'pages',
      where: 'documentId = ?',
      whereArgs: [documentId],
    );
  }
  
  // Tool History CRUD operations
  static Future<void> insertToolHistory(ToolHistoryModel history) async {
    final db = await database;
    await db.insert(
      'tool_history',
      history.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  static Future<List<ToolHistoryModel>> getAllToolHistory() async {
    final db = await database;
    final maps = await db.query(
      'tool_history',
      orderBy: 'timestamp DESC',
    );
    
    return List.generate(maps.length, (i) {
      return ToolHistoryModel.fromMap(maps[i]);
    });
  }
  
  // Initialize database with test data
  static Future<void> initialize() async {
    await database;
    
    // Test insert and read
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
    
    await insertDocument(testDoc);
    final retrievedDoc = await getDocument('test-001');
    
    if (retrievedDoc != null) {
      print('✅ Database test successful: ${retrievedDoc.title}');
    } else {
      print('❌ Database test failed');
    }
  }
}