import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/step_indicator.dart';
import '../../shared/widgets/primary_button.dart';
import 'processing_controller.dart';

class ProcessingScreen extends ConsumerStatefulWidget {
  const ProcessingScreen({super.key});

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> {
  @override
  Widget build(BuildContext context) {
    final processingState = ref.watch(processingControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing Document'),
        backgroundColor: AppColors.paperCream,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepIndicator(
                    currentStep: 2,
                    totalSteps: 5,
                    currentStepName: 'Processing',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Document preview
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document Preview',
                          style: AppTypography.h3,
                        ),
                        const SizedBox(height: 12),
                        
                        // Grid of captured pages
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: processingState.capturedPages.length,
                          itemBuilder: (context, index) {
                            final page = processingState.capturedPages[index];
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Column(
                                children: [
                                  // Image placeholder
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.paperCream,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.image,
                                        size: 48,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'Page ${index + 1}',
                                      style: AppTypography.caption,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Processing status
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.paperCream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              processingState.isProcessing
                                  ? Icons.hourglass_top
                                  : Icons.check_circle,
                              color: AppColors.accent,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              processingState.isProcessing
                                  ? 'Processing...'
                                  : 'Ready to continue',
                              style: AppTypography.h4,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        if (processingState.isProcessing)
                          LinearProgressIndicator(
                            value: processingState.progress,
                            backgroundColor: AppColors.divider,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                            minHeight: 4,
                          ),
                        
                        if (processingState.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              processingState.errorMessage!,
                              style: AppTypography.body2.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                if (!processingState.isProcessing && processingState.errorMessage == null)
                  PrimaryButton(
                    text: 'Continue to OCR',
                    icon: Icons.ocr,
                    onPressed: () {
                      ref.read(processingControllerProvider).processPages();
                    },
                  ),
                if (processingState.errorMessage != null)
                  PrimaryButton(
                    text: 'Retry',
                    icon: Icons.refresh,
                    onPressed: () {
                      ref.read(processingControllerProvider).processPages();
                    },
                  ),
                if (processingState.isProcessing)
                  const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}