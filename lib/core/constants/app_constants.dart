class AppConstants {
  // App configuration
  static const String appName = 'Soft Paper';
  static const String packageName = 'com.zonehunterx.softpaper';
  
  // PDF configuration
  static const double pdfMargin = 50.0;
  static const double lineSpacing = 1.5;
  static const double standardPageWidth = 1600.0;
  
  // Page sizes
  static const String pageSizeA4 = 'A4';
  static const String pageSizeLetter = 'Letter';
  
  // Output modes
  static const String modePerfectCopy = 'perfectCopy';
  static const String modeEnhancedScan = 'enhancedScan';
  
  // OCR languages
  static const String languageEnglish = 'en';
  static const String languageHindi = 'hi';
  static const String languagePunjabi = 'pa';
  
  // Compression presets
  static const String compressSmall = 'small';
  static const String compressMedium = 'medium';
  static const String compressHigh = 'high';
  
  // Animation durations
  static const int cleanupAnimationDuration = 700; // milliseconds
  static const int autoCaptureStabilityFrames = 8;
  static const int autoCaptureCountdown = 400; // milliseconds
  
  // Confidence thresholds
  static const double ocrConfidenceThreshold = 0.7;
  
  // File paths
  static const String tempDir = 'temp';
  static const String outputDir = 'output';
  
  // Camera configuration
  static const CameraResolution cameraResolution = CameraResolution.veryHigh;
  
  // Processing steps
  static const List<String> processingSteps = [
    'Detecting page...',
    'Straightening...',
    'Removing shadows...',
    'Denoising...',
    'Normalizing contrast...',
    'Reading text...',
    'Rebuilding page...',
    'Done'
  ];
}

enum CameraResolution {
  low,
  medium,
  high,
  veryHigh,
}