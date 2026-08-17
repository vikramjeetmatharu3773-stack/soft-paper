import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import '../../core/constants/app_constants.dart';

class EdgeDetectionService {
  // Detect document edges using corner detection
  Future<Map<String, dynamic>> detectEdges(String imagePath) async {
    try {
      final image = img.decodeImage(File(imagePath).readAsBytesSync());
      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Convert to grayscale for edge detection
      final grayscale = img.grayscale(image);
      
      // Apply Gaussian blur to reduce noise
      final blurred = img.gaussianBlur(grayscale, 2);
      
      // Apply Sobel edge detection
      final edges = _applySobelEdgeDetection(blurred);
      
      // Find corners using Harris corner detection
      final corners = _findCorners(edges, image.width, image.height);
      
      // Find document boundary
      final documentBoundary = _findDocumentBoundary(corners, image.width, image.height);
      
      return {
        'hasEdges': true,
        'corners': corners,
        'boundary': documentBoundary,
        'confidence': _calculateConfidence(corners, documentBoundary),
        'imageWidth': image.width,
        'imageHeight': image.height,
      };
      
    } catch (e) {
      return {
        'hasEdges': false,
        'error': e.toString(),
        'corners': [],
        'boundary': null,
        'confidence': 0.0,
      };
    }
  }

  // Apply Sobel edge detection
  List<List<int>> _applySobelEdgeDetection(img.Image image) {
    final width = image.width;
    final height = image.height;
    final edges = List.generate(height, (i) => List.generate(width, (j) => 0));
    
    // Sobel kernels
    final sobelX = [
      [-1, 0, 1],
      [-2, 0, 2],
      [-1, 0, 1]
    ];
    
    final sobelY = [
      [-1, -2, -1],
      [0, 0, 0],
      [1, 2, 1]
    ];
    
    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        int gx = 0;
        int gy = 0;
        
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            final pixel = image.getPixel(x + kx, y + ky);
            final intensity = img.getRed(pixel); // Grayscale image
            gx += intensity * sobelX[ky + 1][kx + 1];
            gy += intensity * sobelY[ky + 1][kx + 1];
          }
        }
        
        final magnitude = sqrt(gx * gx + gy * gy).toInt();
        edges[y][x] = magnitude.clamp(0, 255);
      }
    }
    
    return edges;
  }

  // Find corners using Harris corner detection
  List<Map<String, dynamic>> _findCorners(
    List<List<int>> edges, 
    int width, 
    int height
  ) {
    final corners = <Map<String, dynamic>>[];
    const threshold = 100; // Edge detection threshold
    
    // Simple corner detection - find local maxima in edge map
    for (int y = 1; y < height - 1; y += 10) { // Sample every 10 pixels
      for (int x = 1; x < width - 1; x += 10) {
        final current = edges[y][x];
        
        if (current > threshold) {
          // Check if this is a local maximum
          bool isLocalMax = true;
          for (int dy = -1; dy <= 1; dy++) {
            for (int dx = -1; dx <= 1; dx++) {
              if (edges[y + dy][x + dx] > current) {
                isLocalMax = false;
                break;
              }
            }
            if (!isLocalMax) break;
          }
          
          if (isLocalMax) {
            corners.add({
              'x': x,
              'y': y,
              'strength': current,
            });
          }
        }
      }
    }
    
    // Find the 4 strongest corners that form a rectangle
    final sortedCorners = List<Map<String, dynamic>>.from(corners)
      ..sort((a, b) => b['strength'].compareTo(a['strength']));
    
    return sortedCorners.take(8).toList(); // Take top 8 corners
  }

  // Find document boundary from corners
  Map<String, dynamic>? _findDocumentBoundary(
    List<Map<String, dynamic>> corners, 
    int width, 
    int height
  ) {
    if (corners.length < 4) {
      return null;
    }
    
    // Group corners into quadrants
    final topLeft = corners.where((c) => c['x'] < width / 2 && c['y'] < height / 2);
    final topRight = corners.where((c) => c['x'] >= width / 2 && c['y'] < height / 2);
    final bottomLeft = corners.where((c) => c['x'] < width / 2 && c['y'] >= height / 2);
    final bottomRight = corners.where((c) => c['x'] >= width / 2 && c['y'] >= height / 2);
    
    if (topLeft.isEmpty || topRight.isEmpty || bottomLeft.isEmpty || bottomRight.isEmpty) {
      return null;
    }
    
    // Find strongest corner in each quadrant
    final bestTopLeft = topLeft.reduce((a, b) => a['strength'] > b['strength'] ? a : b);
    final bestTopRight = topRight.reduce((a, b) => a['strength'] > b['strength'] ? a : b);
    final bestBottomLeft = bottomLeft.reduce((a, b) => a['strength'] > b['strength'] ? a : b);
    final bestBottomRight = bottomRight.reduce((a, b) => a['strength'] > b['strength'] ? a : b);
    
    return {
      'topLeft': bestTopLeft,
      'topRight': bestTopRight,
      'bottomLeft': bestBottomLeft,
      'bottomRight': bestBottomRight,
      'center': {
        'x': width / 2,
        'y': height / 2,
      },
    };
  }

  // Calculate confidence score
  double _calculateConfidence(
    List<Map<String, dynamic>> corners, 
    Map<String, dynamic>? boundary
  ) {
    if (boundary == null) {
      return 0.0;
    }
    
    // Calculate aspect ratio
    final width = boundary['topRight']['x'] - boundary['topLeft']['x'];
    final height = boundary['bottomLeft']['y'] - boundary['topLeft']['y'];
    final aspectRatio = width / height;
    
    // Check if aspect ratio is reasonable (between 0.5 and 2.0 for typical documents)
    final aspectRatioScore = aspectRatio > 0.5 && aspectRatio < 2.0 ? 1.0 : 0.5;
    
    // Check corner strength
    final avgStrength = corners.take(4).fold(0, (sum, corner) => sum + corner['strength']) / 4;
    final strengthScore = (avgStrength / 255).clamp(0.0, 1.0);
    
    return (aspectRatioScore * 0.5) + (strengthScore * 0.5);
  }

  // Apply perspective correction to image
  Future<String> applyPerspectiveCorrection(
    String inputPath, 
    Map<String, dynamic> boundary
  ) async {
    try {
      final image = img.decodeImage(File(inputPath).readAsBytesSync());
      if (image == null) {
        throw Exception('Failed to decode image');
      }
      
      // Extract corner points
      final tl = boundary['topLeft'];
      final tr = boundary['topRight'];
      final bl = boundary['bottomLeft'];
      final br = boundary['bottomRight'];
      
      // Apply perspective transformation
      // This is a simplified version - in production, you'd use a proper transformation library
      final corrected = img.copyCrop(
        image,
        x: tl['x'].toInt(),
        y: tl['y'].toInt(),
        width: (tr['x'] - tl['x']).toInt(),
        height: (bl['y'] - tl['y']).toInt(),
      );
      
      // Save corrected image
      final outputPath = inputPath.replaceAll('.jpg', '_corrected.jpg');
      File(outputPath).writeAsBytesSync(img.encodeJpg(corrected));
      
      return outputPath;
      
    } catch (e) {
      throw Exception('Failed to apply perspective correction: $e');
    }
  }
}
