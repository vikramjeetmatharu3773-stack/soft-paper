import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'data/db/database_helper.dart';
import 'features/capture/capture_controller.dart';
import 'features/processing/processing_controller.dart';
import 'features/ocr/ocr_controller.dart';
import 'features/reconstruction/reconstruction_controller.dart';
import 'features/pdf_tools/pdf_tools_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseHelper.initialize();
  
  runApp(const ProviderScope(child: SoftPaperApp()));
}

class SoftPaperApp extends StatelessWidget {
  const SoftPaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Soft Paper',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}