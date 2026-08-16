import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../core/constants/app_constants.dart';
import '../../data/models/document_model.dart';

class CaptureState {
  final List<CapturedPage> capturedPages;
  final bool isCapturing;
  final String? errorMessage;
  
  const CaptureState({
    this.capturedPages = const [],
    this.isCapturing = false,
    this.errorMessage,
  });
  
  CaptureState copyWith({
    List<CapturedPage>? capturedPages,
    bool? isCapturing,
    String? errorMessage,
  }) {
    return CaptureState(
      capturedPages: capturedPages ?? this.capturedPages,
      isCapturing: isCapturing ?? this.isCapturing,
      errorMessage: errorMessage,
    );
  }
}

class CapturedPage {
  final String id;
  final String imagePath;
  final DateTime capturedAt;
  final bool isFromGallery;
  final bool isFromPdf;
  
  CapturedPage({
    required this.id,
    required this.imagePath,
    required this.capturedAt,
    this.isFromGallery = false,
    this.isFromPdf = false,
  });
}

class CaptureController extends StateNotifier<CaptureState> {
  CaptureController() : super(const CaptureState());
  
  final ImagePicker _picker = ImagePicker();
  
  Future<void> captureImage(CameraController controller) async {
    state = state.copyWith(isCapturing: true);
    
    try {
      final XFile image = await controller.takePicture();
      
      // Save to a more permanent location
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'capture_$timestamp.jpg';
      final savedPath = path.join(appDir.path, 'temp', fileName);
      
      // Ensure temp directory exists
      await Directory(path.dirname(savedPath)).create(recursive: true);
      
      // Copy the image
      final savedFile = await File(image.path).copy(savedPath);
      
      final capturedPage = CapturedPage(
        id: 'page_${timestamp}',
        imagePath: savedFile.path,
        capturedAt: DateTime.now(),
        isFromGallery: false,
        isFromPdf: false,
      );
      
      state = state.copyWith(
        capturedPages: [...state.capturedPages, capturedPage],
        isCapturing: false,
      );
      
    } catch (e) {
      state = state.copyWith(
        isCapturing: false,
        errorMessage: 'Failed to capture image: $e',
      );
    }
  }
  
  Future<void> importFromGallery() async {
    state = state.copyWith(isCapturing: true);
    
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        maxWidth: 4032,
        maxHeight: 3024,
      );
      
      if (image != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'gallery_$timestamp.jpg';
        final savedPath = path.join(appDir.path, 'temp', fileName);
        
        // Ensure temp directory exists
        await Directory(path.dirname(savedPath)).create(recursive: true);
        
        // Copy the image
        final savedFile = await File(image.path).copy(savedPath);
        
        final capturedPage = CapturedPage(
          id: 'page_${timestamp}',
          imagePath: savedFile.path,
          capturedAt: DateTime.now(),
          isFromGallery: true,
          isFromPdf: false,
        );
        
        state = state.copyWith(
          capturedPages: [...state.capturedPages, capturedPage],
          isCapturing: false,
        );
      } else {
        state = state.copyWith(isCapturing: false);
      }
      
    } catch (e) {
      state = state.copyWith(
        isCapturing: false,
        errorMessage: 'Failed to import image: $e',
      );
    }
  }
  
  Future<void> importPdf() async {
    state = state.copyWith(isCapturing: true);
    
    try {
      final XFile? pdfFile = await _picker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      
      if (pdfFile != null) {
        // This would be implemented with PDF rendering
        // For now, just create a placeholder
        final appDir = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'pdf_$timestamp.pdf';
        final savedPath = path.join(appDir.path, 'temp', fileName);
        
        // Copy the PDF
        await File(pdfFile.path).copy(savedPath);
        
        // For now, create a placeholder page
        // In real implementation, this would render each PDF page as an image
        final placeholderPage = CapturedPage(
          id: 'page_${timestamp}',
          imagePath: savedPath, // This would be the first rendered page
          capturedAt: DateTime.now(),
          isFromGallery: false,
          isFromPdf: true,
        );
        
        state = state.copyWith(
          capturedPages: [...state.capturedPages, placeholderPage],
          isCapturing: false,
        );
      } else {
        state = state.copyWith(isCapturing: false);
      }
      
    } catch (e) {
      state = state.copyWith(
        isCapturing: false,
        errorMessage: 'Failed to import PDF: $e',
      );
    }
  }
  
  void removePage(int index) {
    final newPages = List<CapturedPage>.from(state.capturedPages);
    if (index >= 0 && index < newPages.length) {
      newPages.removeAt(index);
      state = state.copyWith(capturedPages: newPages);
    }
  }
  
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
  
  List<CapturedPage> get capturedPages => state.capturedPages;
  int get pageCount => state.capturedPages.length;
}

final captureControllerProvider = StateNotifierProvider<CaptureController, CaptureState>(
  (ref) => CaptureController(),
);