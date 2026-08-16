import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/document_model.dart';

class PDFToolsState {
  final List<DocumentModel> recentDocuments;
  final bool isProcessing;
  final double progress;
  final String? errorMessage;
  final DocumentModel? selectedDocument;
  
  const PDFToolsState({
    this.recentDocuments = const [],
    this.isProcessing = false,
    this.progress = 0.0,
    this.errorMessage,
    this.selectedDocument,
  });
  
  PDFToolsState copyWith({
    List<DocumentModel>? recentDocuments,
    bool? isProcessing,
    double? progress,
    String? errorMessage,
    DocumentModel? selectedDocument,
  }) {
    return PDFToolsState(
      recentDocuments: recentDocuments ?? this.recentDocuments,
      isProcessing: isProcessing ?? this.isProcessing,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
      selectedDocument: selectedDocument ?? this.selectedDocument,
    );
  }
}

class PDFToolsController extends StateNotifier<PDFToolsState> {
  PDFToolsController() : super(const PDFToolsState());
  
  Future<void> loadRecentDocuments() async {
    state = state.copyWith(isProcessing: true);
    
    try {
      // Simulate loading recent documents
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Generate mock recent documents
      final documents = _generateMockDocuments();
      
      state = state.copyWith(
        isProcessing: false,
        recentDocuments: documents,
      );
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to load documents: $e',
      );
    }
  }
  
  List<DocumentModel> _generateMockDocuments() {
    final documents = <DocumentModel>[];
    final now = DateTime.now();
    
    for (int i = 0; i < 5; i++) {
      final document = DocumentModel(
        id: 'doc_${i}',
        title: 'Document ${i + 1}',
        createdAt: now.subtract(Duration(days: i)),
        pageCount: 2 + i,
        mode: 'perfectCopy',
        filePath: '/path/to/document_${i}.pdf',
        thumbnailPath: '/path/to/thumbnail_${i}.jpg',
        sourceType: i % 2 == 0 ? 'camera' : 'gallery',
      );
      documents.add(document);
    }
    
    return documents;
  }
  
  Future<void> compressPDF(String filePath) async {
    state = state.copyWith(
      isProcessing: true,
      progress: 0.0,
      errorMessage: null,
    );
    
    try {
      // Simulate compression process
      for (int i = 0; i <= 100; i += 10) {
        state = state.copyWith(progress: i / 100);
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      // Generate compressed file path
      final compressedPath = filePath.replaceAll('.pdf', '_compressed.pdf');
      
      state = state.copyWith(
        isProcessing: false,
        progress: 1.0,
      );
      
      // Show success message
      print('PDF compressed successfully: $compressedPath');
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to compress PDF: $e',
      );
    }
  }
  
  Future<void> encryptPDF(String filePath, String password) async {
    state = state.copyWith(
      isProcessing: true,
      progress: 0.0,
      errorMessage: null,
    );
    
    try {
      // Simulate encryption process
      for (int i = 0; i <= 100; i += 10) {
        state = state.copyWith(progress: i / 100);
        await Future.delayed(const Duration(milliseconds: 300));
      }
      
      // Generate encrypted file path
      final encryptedPath = filePath.replaceAll('.pdf', '_encrypted.pdf');
      
      state = state.copyWith(
        isProcessing: false,
        progress: 1.0,
      );
      
      // Show success message
      print('PDF encrypted successfully: $encryptedPath');
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to encrypt PDF: $e',
      );
    }
  }
  
  Future<void> decryptPDF(String filePath, String password) async {
    state = state.copyWith(
      isProcessing: true,
      progress: 0.0,
      errorMessage: null,
    );
    
    try {
      // Simulate decryption process
      for (int i = 0; i <= 100; i += 10) {
        state = state.copyWith(progress: i / 100);
        await Future.delayed(const Duration(milliseconds: 250));
      }
      
      // Generate decrypted file path
      final decryptedPath = filePath.replaceAll('_encrypted.pdf', '.pdf');
      
      state = state.copyWith(
        isProcessing: false,
        progress: 1.0,
      );
      
      // Show success message
      print('PDF decrypted successfully: $decryptedPath');
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to decrypt PDF: $e',
      );
    }
  }
  
  Future<void> convertPDF(String filePath, String format) async {
    state = state.copyWith(
      isProcessing: true,
      progress: 0.0,
      errorMessage: null,
    );
    
    try {
      // Simulate conversion process
      for (int i = 0; i <= 100; i += 10) {
        state = state.copyWith(progress: i / 100);
        await Future.delayed(const Duration(milliseconds: 400));
      }
      
      // Generate converted file path
      final convertedPath = filePath.replaceAll('.pdf', '.$format');
      
      state = state.copyWith(
        isProcessing: false,
        progress: 1.0,
      );
      
      // Show success message
      print('PDF converted successfully to $format: $convertedPath');
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to convert PDF: $e',
      );
    }
  }
  
  Future<void> rotatePDF(String filePath, int degrees) async {
    state = state.copyWith(
      isProcessing: true,
      progress: 0.0,
      errorMessage: null,
    );
    
    try {
      // Simulate rotation process
      for (int i = 0; i <= 100; i += 10) {
        state = state.copyWith(progress: i / 100);
        await Future.delayed(const Duration(milliseconds: 150));
      }
      
      // Generate rotated file path
      final rotatedPath = filePath.replaceAll('.pdf', '_rotated.pdf');
      
      state = state.copyWith(
        isProcessing: false,
        progress: 1.0,
      );
      
      // Show success message
      print('PDF rotated successfully by $degrees degrees: $rotatedPath');
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to rotate PDF: $e',
      );
    }
  }
  
  Future<void> extractPages(String filePath, List<int> pageNumbers) async {
    state = state.copyWith(
      isProcessing: true,
      progress: 0.0,
      errorMessage: null,
    );
    
    try {
      // Simulate extraction process
      for (int i = 0; i <= 100; i += 10) {
        state = state.copyWith(progress: i / 100);
        await Future.delayed(const Duration(milliseconds: 300));
      }
      
      // Generate extracted file path
      final extractedPath = filePath.replaceAll('.pdf', '_extracted.pdf');
      
      state = state.copyWith(
        isProcessing: false,
        progress: 1.0,
      );
      
      // Show success message
      print('PDF pages extracted successfully: $extractedPath');
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to extract pages: $e',
      );
    }
  }
  
  Future<void> mergePDFs(List<String> filePaths) async {
    state = state.copyWith(
      isProcessing: true,
      progress: 0.0,
      errorMessage: null,
    );
    
    try {
      // Simulate merge process
      for (int i = 0; i <= 100; i += 10) {
        state = state.copyWith(progress: i / 100);
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      // Generate merged file path
      final mergedPath = filePaths.first.replaceAll('.pdf', '_merged.pdf');
      
      state = state.copyWith(
        isProcessing: false,
        progress: 1.0,
      );
      
      // Show success message
      print('PDFs merged successfully: $mergedPath');
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to merge PDFs: $e',
      );
    }
  }
  
  Future<void> splitPDF(String filePath, List<int> splitPoints) async {
    state = state.copyWith(
      isProcessing: true,
      progress: 0.0,
      errorMessage: null,
    );
    
    try {
      // Simulate split process
      for (int i = 0; i <= 100; i += 10) {
        state = state.copyWith(progress: i / 100);
        await Future.delayed(const Duration(milliseconds: 400));
      }
      
      // Generate split file paths
      final splitPaths = splitPoints.map((point) {
        return filePath.replaceAll('.pdf', '_part${point}.pdf');
      }).toList();
      
      state = state.copyWith(
        isProcessing: false,
        progress: 1.0,
      );
      
      // Show success message
      print('PDF split successfully: $splitPaths');
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to split PDF: $e',
      );
    }
  }
  
  Future<void> shareDocument(String filePath) async {
    try {
      await Share.shareXFiles(
        [XFile(filePath, name: path.basename(filePath))],
        subject: 'Share Document',
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to share document: $e',
      );
    }
  }
  
  void deleteDocument(String documentId) {
    final updatedDocuments = state.recentDocuments
        .where((doc) => doc.id != documentId)
        .toList();
    
    state = state.copyWith(recentDocuments: updatedDocuments);
  }
  
  void setSelectedDocument(DocumentModel document) {
    state = state.copyWith(selectedDocument: document);
  }
  
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
  
  List<DocumentModel> get recentDocuments => state.recentDocuments;
  bool get isProcessing => state.isProcessing;
  double get progress => state.progress;
  String? get errorMessage => state.errorMessage;
  DocumentModel? get selectedDocument => state.selectedDocument;
}

final pdfToolsControllerProvider = StateNotifierProvider<PDFToolsController, PDFToolsState>(
  (ref) => PDFToolsController(),
);