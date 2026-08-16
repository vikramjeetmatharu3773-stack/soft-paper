import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DocumentModel {
  final String id;
  final String title;
  final DateTime createdAt;
  final int pageCount;
  final String mode; // 'perfectCopy' or 'enhancedScan'
  final String filePath;
  final String? thumbnailPath;
  final String sourceType; // 'camera', 'gallery', 'pdf'
  
  DocumentModel({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.pageCount,
    required this.mode,
    required this.filePath,
    this.thumbnailPath,
    required this.sourceType,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'pageCount': pageCount,
      'mode': mode,
      'filePath': filePath,
      'thumbnailPath': thumbnailPath,
      'sourceType': sourceType,
    };
  }
  
  static DocumentModel fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.parse(map['createdAt']),
      pageCount: map['pageCount'],
      mode: map['mode'],
      filePath: map['filePath'],
      thumbnailPath: map['thumbnailPath'],
      sourceType: map['sourceType'],
    );
  }
}

class PageModel {
  final String id;
  final String documentId;
  final int orderIndex;
  final String originalImagePath;
  final String processedImagePath;
  final String? ocrText;
  final String? layoutJson;
  
  PageModel({
    required this.id,
    required this.documentId,
    required this.orderIndex,
    required this.originalImagePath,
    required this.processedImagePath,
    this.ocrText,
    this.layoutJson,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'documentId': documentId,
      'orderIndex': orderIndex,
      'originalImagePath': originalImagePath,
      'processedImagePath': processedImagePath,
      'ocrText': ocrText,
      'layoutJson': layoutJson,
    };
  }
  
  static PageModel fromMap(Map<String, dynamic> map) {
    return PageModel(
      id: map['id'],
      documentId: map['documentId'],
      orderIndex: map['orderIndex'],
      originalImagePath: map['originalImagePath'],
      processedImagePath: map['processedImagePath'],
      ocrText: map['ocrText'],
      layoutJson: map['layoutJson'],
    );
  }
}

class ToolHistoryModel {
  final String id;
  final String toolType;
  final String inputPath;
  final String outputPath;
  final DateTime timestamp;
  
  ToolHistoryModel({
    required this.id,
    required this.toolType,
    required this.inputPath,
    required this.outputPath,
    required this.timestamp,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'toolType': toolType,
      'inputPath': inputPath,
      'outputPath': outputPath,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  static ToolHistoryModel fromMap(Map<String, dynamic> map) {
    return ToolHistoryModel(
      id: map['id'],
      toolType: map['toolType'],
      inputPath: map['inputPath'],
      outputPath: map['outputPath'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}