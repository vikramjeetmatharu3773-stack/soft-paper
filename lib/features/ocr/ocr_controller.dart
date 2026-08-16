import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;
import '../../core/constants/app_constants.dart';
import '../../features/processing/processing_controller.dart';
import '../../features/capture/capture_controller.dart';

class OCRState {
  final List<ProcessedPage> processedPages;
  final bool isProcessing;
  final double progress;
  final String? errorMessage;
  final double averageConfidence;
  final double qualityLevel;
  final List<String> supportedLanguages;
  final String selectedLanguage;
  
  const OCRState({
    this.processedPages = const [],
    this.isProcessing = false,
    this.progress = 0.0,
    this.errorMessage,
    this.averageConfidence = 0.0,
    this.qualityLevel = 1.0,
    this.supportedLanguages = const ['English', 'Spanish', 'French', 'German'],
    this.selectedLanguage = 'English',
  });
  
  OCRState copyWith({
    List<ProcessedPage>? processedPages,
    bool? isProcessing,
    double? progress,
    String? errorMessage,
    double? averageConfidence,
    double? qualityLevel,
    List<String>? supportedLanguages,
    String? selectedLanguage,
  }) {
    return OCRState(
      processedPages: processedPages ?? this.processedPages,
      isProcessing: isProcessing ?? this.isProcessing,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
      averageConfidence: averageConfidence ?? this.averageConfidence,
      qualityLevel: qualityLevel ?? this.qualityLevel,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

class OCRController extends StateNotifier<OCRState> {
  OCRController() : super(const OCRState());
  
  Future<void> processOCR() async {
    state = state.copyWith(
      isProcessing: true,
      progress: 0.0,
      errorMessage: null,
    );
    
    try {
      // In a real implementation, this would process each page with OCR
      // For now, we'll simulate OCR processing
      
      final processedPages = state.processedPages;
      final totalPages = processedPages.length;
      double totalConfidence = 0.0;
      
      for (int i = 0; i < processedPages.length; i++) {
        final page = processedPages[i];
        final progress = (i + 1) / totalPages;
        
        // Update progress
        state = state.copyWith(progress: progress);
        
        // Simulate OCR processing
        await Future.delayed(Duration(milliseconds: 1000 ~/ state.qualityLevel));
        
        // Generate mock OCR text based on page content
        final mockText = _generateMockOCRText(page);
        
        // Calculate confidence based on image quality and OCR settings
        final confidence = _calculateConfidence(page, state.qualityLevel);
        
        // Update the page with OCR results
        final updatedPage = page.copyWith(
          ocrText: mockText,
        );
        
        processedPages[i] = updatedPage;
        totalConfidence += confidence;
        
        // Small delay to show progress
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      final averageConfidence = totalPages > 0 ? totalConfidence / totalPages : 0.0;
      
      state = state.copyWith(
        isProcessing: false,
        processedPages: processedPages,
        progress: 1.0,
        averageConfidence: averageConfidence,
      );
      
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to process OCR: $e',
      );
    }
  }
  
  String _generateMockOCRText(ProcessedPage page) {
    // Generate mock OCR text based on page type
    if (page.isFromPdf) {
      return 'PDF Document Content\n\nThis is a simulated OCR result from a PDF document. In a real implementation, this would contain the actual text extracted from the PDF pages using Tesseract OCR or Google ML Kit Text Recognition.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.';
    } else if (page.isFromGallery) {
      return 'Gallery Image Content\n\nThis is a simulated OCR result from a gallery image. In production, this would contain the actual text extracted from the image using Google ML Kit Text Recognition.\n\nThe quick brown fox jumps over the lazy dog. This sentence contains all letters of the English alphabet and is commonly used to test fonts and OCR systems.';
    } else {
      return 'Camera Capture Content\n\nThis is a simulated OCR result from a camera capture. In production, this would contain the actual text extracted from the document using Google ML Kit Text Recognition.\n\nDocument Title: Sample Document\n\nPage 1 of 3\n\nThis is the content of the first page. It contains various text that would be recognized by the OCR system and converted to digital text format.';
    }
  }
  
  double _calculateConfidence(ProcessedPage page, double qualityLevel) {
    // Base confidence based on image source
    double baseConfidence = 0.7; // Default confidence
    
    if (page.isFromPdf) {
      baseConfidence = 0.9; // PDFs usually have high quality
    } else if (page.isFromGallery) {
      baseConfidence = 0.8; // Gallery images are usually good quality
    } else {
      baseConfidence = 0.6; // Camera captures may vary in quality
    }
    
    // Apply quality level modifier
    final confidence = baseConfidence * qualityLevel;
    
    // Add some randomness to simulate real OCR results
    final randomFactor = 0.8 + (Random().nextDouble() * 0.2);
    
    return confidence * randomFactor;
  }
  
  void setQualityLevel(double level) {
    state = state.copyWith(qualityLevel: level);
  }
  
  void setSelectedLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
  }
  
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
  
  List<ProcessedPage> get processedPages => state.processedPages;
  bool get isProcessing => state.isProcessing;
  double get progress => state.progress;
  String? get errorMessage => state.errorMessage;
  double get averageConfidence => state.averageConfidence;
}

final ocrControllerProvider = StateNotifierProvider<OCRController, OCRState>(
  (ref) => OCRController(),
);