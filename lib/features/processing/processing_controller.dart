import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../core/constants/app_constants.dart';
import '../../features/capture/capture_controller.dart';
import '../../features/edge_detection/edge_detection_service.dart';
import '../../data/models/document_model.dart';

class ProcessingState {
  final List<CapturedPage> capturedPages;
  final bool isProcessing;
  final double progress;
  final String? errorMessage;
  final List<ProcessedPage> processedPages;
  
  const ProcessingState({
    this.capturedPages = const [],
    this.isProcessing = false,
    this.progress = 0.0,
    this.errorMessage,
    this.processedPages = const [],
  });
  
  ProcessingState copyWith({
    List<CapturedPage>? capturedPages,
    bool? isProcessing,
    double? progress,
    String? errorMessage,
    List<ProcessedPage>? processedPages,
  }) {
    return ProcessingState(
      capturedPages: capturedPages ?? this.capturedPages,
      isProcessing: isProcessing ?? this.isProcessing,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
      processedPages: processedPages ?? this.processedPages,
    );
  }
}

class ProcessedPage {
  final String id;
  final String originalImagePath;
  final String processedImagePath;
  final String ocrText;
  final DateTime processedAt;
  final Map<String, dynamic>? edgeDetectionResult;
  final bool isFromGallery;
  final bool isFromPdf;
  
  ProcessedPage({
    required this.id,
    required this.originalImagePath,
    required this.processedImagePath,
    required this.ocrText,
    required this.processedAt,
    this.edgeDetectionResult,
    this.isFromGallery = false,
    this.isFromPdf = false,
  });
}

class ProcessingController extends StateNotifier<ProcessingState> {
  ProcessingController() : super(const ProcessingState());
  
  final EdgeDetectionService _edgeDetectionService = EdgeDetectionService();
  
  Future<void> processPages() async {
    state = state.copyWith(
      isProcessing: true,
      progress: 0.0,
      errorMessage: null,
    );
    
    try {
      final capturedPages = state.capturedPages;
      final processedPages = <ProcessedPage>[];
      
      for (int i = 0; i < capturedPages.length; i++) {
        final page = capturedPages[i];
        final progress = (i + 1) / capturedPages.length;
        
        // Update progress
        state = state.copyWith(progress: progress);
        
        // Process the page
        final processedPage = await _processSinglePage(page);
        processedPages.add(processedPage);
        
        // Small delay to show progress
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      state = state.copyWith(
        isProcessing: false,
        processedPages: processedPages,
        progress: 1.0,
      );
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to process pages: $e',
      );
    }
  }
  
  Future<ProcessedPage> _processSinglePage(CapturedPage page) async {
    // Apply edge detection and correction
    final edgeDetectionResult = await _edgeDetectionService.detectEdges(page.imagePath);
    
    String correctedImagePath = page.imagePath;
    if (edgeDetectionResult['hasEdges'] == true && edgeDetectionResult['boundary'] != null) {
      try {
        correctedImagePath = await _edgeDetectionService.applyPerspectiveCorrection(
          page.imagePath,
          edgeDetectionResult['boundary']!,
        );
      } catch (e) {
        print('Perspective correction failed: $e');
      }
    }
    
    // Apply OCR
    String ocrText = '';
    try {
      ocrText = await _applyOCR(correctedImagePath);
    } catch (e) {
      print('OCR failed: $e');
    }
    
    return ProcessedPage(
      id: page.id,
      originalImagePath: page.imagePath,
      processedImagePath: correctedImagePath,
      ocrText: ocrText,
      processedAt: DateTime.now(),
      edgeDetectionResult: edgeDetectionResult,
      isFromGallery: page.isFromGallery,
      isFromPdf: page.isFromPdf,
    );
  }
  
  Future<String> _applyOCR(String imagePath) async {
    // This would integrate with Google ML Kit or Tesseract OCR
    // For now, return placeholder text
    await Future.delayed(const Duration(seconds: 1)); // Simulate OCR processing
    
    return 'OCR text extracted from image. This would contain the actual text content from the document.';
  }
  
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
  
  List<ProcessedPage> get processedPages => state.processedPages;
  bool get isProcessing => state.isProcessing;
  double get progress => state.progress;
  String? get errorMessage => state.errorMessage;
}

final processingControllerProvider = StateNotifierProvider<ProcessingController, ProcessingState>(
  (ref) => ProcessingController(),
);