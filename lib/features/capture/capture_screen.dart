import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/primary_button.dart';
import 'capture_controller.dart';

class CaptureScreen extends ConsumerStatefulWidget {
  const CaptureScreen({super.key});

  @override
  ConsumerState<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends ConsumerState<CaptureScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _hasPermission = false;
  bool _showPermissionRationale = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final storageStatus = await Permission.storage.request();
    
    setState(() {
      _hasPermission = cameraStatus.isGranted && storageStatus.isGranted;
      _showPermissionRationale = cameraStatus.isPermanentlyDenied || storageStatus.isPermanentlyDenied;
    });

    if (_hasPermission) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );

        _controller = CameraController(
          backCamera,
          ResolutionPreset.veryHigh,
        );

        await _controller!.initialize();
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showPermissionRationale) {
      return _buildPermissionRationale();
    }

    if (!_hasPermission) {
      return _buildPermissionRequest();
    }

    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Capture Pages'),
        backgroundColor: AppColors.paperCream,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CameraPreview(_controller!),
                const EdgeOverlayPainter(),
                const Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: BatchCounterWidget(),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                PrimaryButton(
                  text: 'Capture Page',
                  icon: Icons.camera_alt,
                  onPressed: () {
                    ref.read(captureControllerProvider).captureImage(_controller!);
                  },
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: 'Import from Gallery',
                  icon: Icons.photo_library,
                  onPressed: () {
                    ref.read(captureControllerProvider).importFromGallery();
                  },
                  isFullWidth: true,
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: 'Import PDF',
                  icon: Icons.picture_as_pdf,
                  onPressed: () {
                    ref.read(captureControllerProvider).importPdf();
                  },
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRequest() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions Required'),
        backgroundColor: AppColors.paperCream,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt,
                size: 64,
                color: AppColors.accent,
              ),
              const SizedBox(height: 20),
              Text(
                'Camera and Storage Permissions Required',
                style: AppTypography.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Soft Paper needs access to your camera and storage to capture and save documents.',
                style: AppTypography.body2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Grant Permissions',
                onPressed: _checkPermissions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionRationale() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions Required'),
        backgroundColor: AppColors.paperCream,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 20),
              Text(
                'Permissions Denied',
                style: AppTypography.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Please enable camera and storage permissions in app settings to use Soft Paper.',
                style: AppTypography.body2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Open Settings',
                onPressed: () => openAppSettings(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}